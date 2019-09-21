/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit

class Well {
    // Properties
    
    // Delegate responsible for functionality dependent on the well
    private( set ) var delegate  : WellDelegate
    
    // All bulbs that have landed in the well
    private( set ) var contents  : [ [ Bulb ] ]
    
    // Current stoplight dropping in, if any
    private( set ) var stopLight : StopLight?
    
    // Initializers
    
    init( rows : Int, cols : Int, delegate : WellDelegate ) {
        // Well starts as all empty bulbs
        contents = ( 0...( rows - 1) ).map { row in
            return ( 0...( cols - 1 ) ).map { col in
                return Bulb( ofType : .empty )
            }
        }
        
        self.delegate = delegate
        self.drawTo( well : self.delegate.delegate.well )
    }
    
    convenience init( delegate : WellDelegate ) {
        // Create a well that matches the size of an on-screen one
        // managed by the delegate
        let rows = delegate.delegate.well.subviews.count
        let cols = delegate.delegate.well.subviews.first!.subviews.count
        
        self.init( rows : rows, cols : cols, delegate : delegate )
    }
    
    // Methods
    
    // Draw the game's well to the game screen's well
    func drawTo( well : UIView ) {
        // Any ghost bulbs dropped into and settled at the bottom of the well will
        // be replaced so empty them
        for row in contents.enumerated() { for col in row.element.enumerated() {
            if col.element.bulbType == .ghost {
                contents[ row.offset ][ col.offset ] = Bulb ( ofType : .empty )
            }
        } }
        
        // Get the dropped stoplight if any and its ghost
        guard let light = stopLight else { return }
        let       ghost = light.ghost
        
        // Drop the ghost until it bottoms out
        while !willCollide( stopLight : ghost, fromAction : StopLight.dropDown ) { ghost.dropDown() }
        
        // Land it and settle the well's contents
        land( ghost )
        settle()
        
        // Match the game screen well's bulbs to those of the game well
        well.subviews.enumerated().forEach { row in
            row.element.subviews.enumerated().forEach { col in
                ( col.element as! UIImageView ).image = contents[ row.offset ][ col.offset ].image
            }
        }
        
        // Then, match the game screen well's bulbs that corresond to the dropping
        // stoplight's, ignoring empty bulbs
        light.contents.enumerated().forEach { row in
            row.element.enumerated().forEach { col in
                let bulb = light.contents[ row.offset ][ col.offset ]
                
                guard bulb.bulbType != .empty, row.offset + light.top >= 0 else { return }
                
                ( well.subviews[ light.top  + row.offset ]
                    .subviews[ light.left + col.offset ] as! UIImageView ).image = bulb.image
            }
        }
    }
    
    // Determine if some action applied to the dropping stoplight will cause it to collide
    // with the well's bounds or bulbs already landed it
    func willCollide( stopLight : StopLight, fromAction : ( StopLight ) -> () -> () ) -> Bool {
        // Make a copy of the provided stoplight to apply the provided action to
        let tested = StopLight( top : stopLight.top, left : stopLight.left, shape : stopLight.shape )
        // Reify the provided action as one to be applied to the stoplight
        let action = fromAction( tested )
        
        // And, then do it
        action()
        
        // Check the acted upon test stoplight non-empty bulbs for overlaps
        for row in tested.contents.enumerated() { for col in row.element.enumerated() {
            // Ignore empty bulbs
            guard col.element.bulbType != .empty else { continue }
            
            // Beyond the well's bounds
            if row.offset + tested.top  >= contents.count        ||
               col.offset + tested.left >= contents.first!.count ||
               col.offset + tested.left <  0 { return true }
            
            // Ignore yet to drop in bulbs
            guard row.offset + tested.top >= 0 else { continue }
            
            // Landed bulb types to ignore for overlaps
            let ignored : [ BulbType ] = [ .empty, .ghost ]
            
            // Overlaps a bulb other than types to ignore
            if ignored.allSatisfy(
                { contents[ row.offset + tested.top ][ col.offset + tested.left ].bulbType != $0 }
            ) { return true }
        } }
        
        return false
    }
    
    // Landing a stoplight adds its bulbs to the contents of the well, each offset by their
    // position in the stoplight's contents and it coordinates in the well
    func land( _ stopLight : StopLight ) {
        for row in stopLight.contents.enumerated() { for col in row.element.enumerated() {
            // Ignore empty bulbs
            guard col.element.bulbType != .empty else { continue }
            
            // Landing outside of the well is overflow or game over
            guard row.offset + stopLight.top >= 0 else {
                // unless its a ghost
                guard col.element.bulbType == .ghost else { delegate.wellDidOverflow( self ); return }
                
                continue
            }
            
            // Land the stoplight
            contents[ row.offset + stopLight.top ][ col.offset + stopLight.left ] = col.element
        } }
    }
    
    // Settling the well ensures that no bulb other than empty bulbs have empty bulbs under them
    func settle() {
        for _ in contents { for row in contents.enumerated() { for col in row.element.enumerated() {
            if col.element.bulbType != .empty && row.offset + 1 < contents.count &&
               contents[ row.offset + 1 ][ col.offset ].bulbType == .empty {
                
                contents[ row.offset + 1 ][ col.offset ] = col.element
                contents[ row.offset     ][ col.offset ] = Bulb( ofType : .empty )
            }
        } } }
    }
    
    // Clearing removes bulbs that have as many bulbs of the same color neighboring them as
    // is their weight.
    func clear() {
        // Recursively clear bulbs from the well, returning the number cleared, if any, or
        // nil if none could be cleared
        func numCleared() -> Int? {
            // Base case
            var cleared = 0
            
            // Bulb types not to bother clearing
            let ignored : [ BulbType ] = [ .empty, .clear, .ghost ]
            
            for row in contents.enumerated() { for col in row.element.enumerated() {
                // Ignore the ignorable bulbs
                guard ignored.allSatisfy( { col.element.bulbType != $0 } ) else { continue }
                
                // Get the current bulb's neighbors of matching type
                let neighbors = neighborsOf( row : row.offset, col : col.offset  )
                let matching  = neighbors.filter { $0.bulbType == col.element.bulbType }
                
                // If the current bulb has enough matching neighbors, mark it for clearing
                if matching.count >= col.element.bulbWeight!.rawValue + 1 {
                    contents[ row.offset ][ col.offset ].clearable = true
                }
            } }
            
            // Change all clearable bulbs to cleared ones, tallying each
            for row in contents.enumerated() { for col in row.element.enumerated() {
                if col.element.clearable {
                    contents[ row.offset ][ col.offset ] = Bulb( ofType : .clear )
                    cleared += 1
                }
            } }
            
            // Check if any bulbs were cleared
            if cleared > 0 {
                // If there were, change them to empty ones
                for row in contents.enumerated() { for col in row.element.enumerated() {
                    if col.element.bulbType == .clear {
                        contents[ row.offset ][ col.offset ] = Bulb( ofType : .empty )
                    }
                } }
                
                // Settle the well, and recursively clear, returning the aggregate tally
                settle()
                return cleared + ( numCleared() ?? 0 )
            }
            
            // No bulbs were cleared
            return nil
        }
        
        // Try to clear bulbs from the well, and report how many were cleared, if any,
        // to the delegate
        if let cleared = numCleared() { delegate.well( self, didClearBulbs : cleared ) }
    }
    
    // Get the neighbors above, below, and to either side of one at specified coordinates
    func neighborsOf( row : Int, col : Int ) -> [ Bulb ] {
        // First and last row edge cases
        let firstRow = 0
        let lastRow  = contents.count        - 1
        
        // First and last column edge cases
        let firstCol = 0
        let lastCol  = contents.first!.count - 1
        
        // Neighbors corresponding to current coordinates
        switch ( row, col ) {
            case ( firstRow, firstCol ) : return [
                contents[ row     ][ col + 1 ],
                contents[ row + 1 ][ col     ]
            ]
            
            case ( firstRow, lastCol  ) : return [
                contents[ row     ][ col - 1 ],
                contents[ row + 1 ][ col     ]
            ]
            
            case ( firstRow, _        ) : return [
                contents[ row     ][ col - 1 ],
                contents[ row     ][ col + 1 ],
                contents[ row + 1 ][ col     ]
            ]
            
            case ( lastRow,  firstCol ) : return [
                contents[ row - 1 ][ col     ],
                contents[ row     ][ col + 1 ]
            ]
            
            case ( lastRow,  lastCol  ) : return [
                contents[ row - 1 ][ col     ],
                contents[ row     ][ col - 1 ]
            ]
            
            case ( lastRow,  _        ) : return [
                contents[ row - 1 ][ col     ],
                contents[ row     ][ col - 1 ],
                contents[ row     ][ col + 1 ]
            ]
            
            case ( _,        firstCol ) : return [
                contents[ row - 1 ][ col     ],
                contents[ row     ][ col + 1 ],
                contents[ row + 1 ][ col     ],
            ]
            
            case ( _,        lastCol ) : return [
                contents[ row - 1 ][ col     ],
                contents[ row     ][ col - 1 ],
                contents[ row + 1 ][ col     ]
            ]
                
            default                     : return [
                contents[ row - 1 ][ col     ],
                contents[ row     ][ col - 1 ],
                contents[ row     ][ col + 1 ],
                contents[ row + 1 ][ col     ]
            ]
            
        }
    }
    
    // Manifest a stoplight from the forecast and add it to the well
    func addStopLight( ) { stopLight = delegate.forecast.manifest() }
    
    // Stoplight manipulations to apply to the curent stoplight, if any
    
    // Cycles cannot cause collisions, but all other manipulations can
    
    func cycleUp() {
        guard let light = stopLight else { return }
        
        light.cycleUp()
    }
    
    func cycleDown() {
        guard let light = stopLight else { return }
        
        light.cycleDown()
    }
    
    func rotateCounter() {
        guard let light = stopLight else { return }
        
        if !willCollide( stopLight: light, fromAction: StopLight.rotateCounter ) {
            light.rotateCounter()
        }
    }
    
    func rotateClock() {
        guard let light = stopLight else { return }
        
        if !willCollide( stopLight: light, fromAction: StopLight.rotateClock ) {
            light.rotateClock()
        }
    }
    
    func moveLeft() {
        guard let light = stopLight else { return }
        
        if !willCollide( stopLight: light, fromAction: StopLight.moveLeft ) {
            light.moveLeft()
        }
    }
    
    func moveRight() {
        guard let light = stopLight else { return }
        
        if !willCollide( stopLight: light, fromAction: StopLight.moveRight ) {
            light.moveRight()
        }
    }
    
    // Drop down is special because stoplights that would collide with anything
    // while dropping  must land, after which the well must be cleared and settled
    // before a new stoplight is added
    
    func dropDown() {
        guard let stopLight = stopLight else { return }
        
        if willCollide( stopLight: stopLight, fromAction: StopLight.dropDown ) {
            land( stopLight )
            settle()
            clear()
            addStopLight()
        } else {
            stopLight.dropDown()
        }
    }
}
