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
    
    private( set ) var delegate  : WellDelegate
    private( set ) var contents  : [ [ Bulb ] ]
    private( set ) var stopLight : StopLight?
    
    // Initializers
    
    init( rows : Int, cols : Int, delegate : WellDelegate ) {
        contents = ( 0...( rows - 1) ).map { row in
            return ( 0...( cols - 1 ) ).map { col in
                return Bulb( ofType : .empty )
            }
        }
        
        self.delegate = delegate
        self.drawTo(well: self.delegate.delegate.well )
        
    }
    
    convenience init( delegate : WellDelegate ) {
        let rows = delegate.delegate.well.subviews.count
        let cols = delegate.delegate.well.subviews.first!.subviews.count
        
        self.init( rows : rows, cols : cols, delegate : delegate )
    }
    
    // Methods
    
    func drawTo( well : UIView ) {
        for row in contents.enumerated() { for col in row.element.enumerated() {
            if col.element.bulbType == .ghost {
                contents[ row.offset ][ col.offset ] = Bulb ( ofType : .empty )
            }
        } }
        
        guard let light = stopLight else { return }
        let       ghost = light.ghost
        
        while !willCollide( stopLight : ghost, fromAction : StopLight.dropDown ) { ghost.dropDown() }
        
        land( ghost )
        settle()
        
        well.subviews.enumerated().forEach { row in
            row.element.subviews.enumerated().forEach { col in
                ( col.element as! UIImageView ).image = contents[ row.offset ][ col.offset ].image
            }
        }
        
        light.contents.enumerated().forEach { row in
            row.element.enumerated().forEach { col in
                let bulb = light.contents[ row.offset ][ col.offset ]
                
                guard bulb.bulbType != .empty, row.offset + light.top >= 0 else { return }
                
                ( well.subviews[ light.top  + row.offset ]
                    .subviews[ light.left + col.offset ] as! UIImageView ).image = bulb.image
            }
        }
    }
    
    func willCollide( stopLight : StopLight, fromAction : ( StopLight ) -> () -> () ) -> Bool {
        let tested = StopLight( top : stopLight.top, left : stopLight.left, shape : stopLight.shape )
        let action = fromAction( tested )
        
        action()
        
        for row in tested.contents.enumerated() { for col in row.element.enumerated() {
            // Ignore Empty Bulbs
            guard col.element.bulbType != .empty else { continue }
            
            // Beyond Well Bounds
            if row.offset + tested.top  >= contents.count        ||
               col.offset + tested.left >= contents.first!.count ||
               col.offset + tested.left <  0 { return true }
            
            // Ignore Yet to Drop In Bulbs
            guard row.offset + tested.top >= 0 else { continue }
            
            // Overlapping Another Bulb
            let ignored : [ BulbType ] = [ .empty, .ghost ]
            
            if ignored.allSatisfy(
                { contents[ row.offset + tested.top ][ col.offset + tested.left ].bulbType != $0 }
            ) { return true }
        } }
        
        return false
    }
    
    func land( _ stopLight : StopLight ) {
        for row in stopLight.contents.enumerated() { for col in row.element.enumerated() {
            // Ignore Empty Bulbs
            guard col.element.bulbType != .empty else { continue }
            
            // Landing Outside of Well Bounds is Game Over
            guard row.offset + stopLight.top >= 0 else {
                guard col.element.bulbType == .ghost else { delegate.wellDidOverflow( self ); return }
                
                continue
            }
            
            contents[ row.offset + stopLight.top ][ col.offset + stopLight.left ] = col.element
        } }
    }
    
    func settle() {
        for _ in contents { for row in contents.enumerated() { for col in row.element.enumerated() {
            if col.element.bulbType != .empty && row.offset + 1 < contents.count &&
               contents[ row.offset + 1 ][ col.offset ].bulbType == .empty {
                
                contents[ row.offset + 1 ][ col.offset ] = col.element
                contents[ row.offset     ][ col.offset ] = Bulb( ofType : .empty )
            }
        } } }
    }
    
    func clear() {
        func numCleared() -> Int? {
            var cleared = 0
            let ignored : [ BulbType ] = [ .empty, .clear, .ghost ]
            
            for row in contents.enumerated() { for col in row.element.enumerated() {
                guard ignored.allSatisfy( { col.element.bulbType != $0 } ) else { continue }
                
                let neighbors = neighborsOf( row : row.offset, col : col.offset  )
                let matching  = neighbors.filter { $0.bulbType == col.element.bulbType }
                
                if matching.count >= col.element.bulbWeight!.rawValue + 1 {
                    contents[ row.offset ][ col.offset ].clearable = true
                }
            } }
            
            for row in contents.enumerated() { for col in row.element.enumerated() {
                if col.element.clearable {
                    contents[ row.offset ][ col.offset ] = Bulb( ofType : .clear )
                    cleared += 1
                }
            } }
            
            if cleared > 0 {
                for row in contents.enumerated() { for col in row.element.enumerated() {
                    if col.element.bulbType == .clear {
                        contents[ row.offset ][ col.offset ] = Bulb( ofType : .empty )
                    }
                } }
                
                settle()
                return cleared + ( numCleared() ?? 0 )
            }
            
            return nil
        }
        
        if let cleared = numCleared() { delegate.well( self, didClearBulbs : cleared ) }
    }
    
    func neighborsOf( row : Int, col : Int ) -> [ Bulb ] {
        let firstRow = 0
        let lastRow  = contents.count        - 1
        
        let firstCol = 0
        let lastCol  = contents.first!.count - 1
        
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
    
    func addStopLight( ) {
        stopLight = delegate.forecast.manifest()
    }
    
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
