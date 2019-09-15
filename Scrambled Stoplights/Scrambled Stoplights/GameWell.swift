/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit

class GameWell {
    // Properties
    
    private( set ) var contents     : [ [ Bulb ] ]
    private        var trafficLight : TrafficLight?
    
    // Initializers
    
    init( rows : Int, cols : Int ) {
        contents = ( 0...( rows - 1) ).map { row in
            return ( 0...( cols - 1 ) ).map { col in
                return Bulb( ofType : .empty )
            }
        }
    }
    
    convenience init( matching screenWell : UIView ) {
        let rows = screenWell.subviews.count
        let cols = screenWell.subviews.first!.subviews.count
        
        self.init( rows : rows, cols : cols )
    }
    
    // Methods
    
    func drawTo( screenWell : UIView ) {
        screenWell.subviews.enumerated().forEach { row in
            row.element.subviews.enumerated().forEach { col in
                ( col.element as! UIImageView ).image = contents[ row.offset ][ col.offset ].image
            }
        }
        
        guard let light = trafficLight else { return }
        
        light.contents.enumerated().forEach { row in
            row.element.enumerated().forEach { col in
                let bulb = light.contents[ row.offset ][ col.offset ]
                
                guard
                    bulb.bulbType != .empty,
                    row.offset + light.top >= 0
                else { return }
                
                ( screenWell.subviews[ light.top  + row.offset ]
                            .subviews[ light.left + col.offset ] as! UIImageView ).image = bulb.image
            }
        }
    }
    
    func addTrafficLight( ) {
        self.trafficLight = TrafficLight( top  : -3, left : ( contents.first!.count - 3 ) / 2 )
    }
    
    func cycleUp() {
        guard let light = trafficLight else { return }
        
        light.cycleUp()
    }
    
    func cycleDown() {
        guard let light = trafficLight else { return }
        
        light.cycleDown()
    }
    
    func rotateCounter() {
        guard let light = trafficLight else { return }
        
        if !willCollide( trafficLight: light, fromAction: TrafficLight.rotateCounter ) {
            light.rotateCounter()
        }
    }
    
    func rotateClock() {
        guard let light = trafficLight else { return }
        
        if !willCollide( trafficLight: light, fromAction: TrafficLight.rotateClock ) {
            light.rotateClock()
        }
    }
    
    func moveLeft() {
        guard let light = trafficLight else { return }
        
        if !willCollide( trafficLight: light, fromAction: TrafficLight.moveLeft ) {
            light.moveLeft()
        }
    }
    
    func moveRight() {
        guard let light = trafficLight else { return }
        
        if !willCollide( trafficLight: light, fromAction: TrafficLight.moveRight ) {
            light.moveRight()
        }
    }
    
    func dropDown() {
        guard let light = trafficLight else { return }
        
        if !willCollide( trafficLight: light, fromAction: TrafficLight.dropDown ) {
            light.dropDown()
        }
    }
    
    func willCollide( trafficLight : TrafficLight, fromAction : ( TrafficLight ) -> () -> () ) -> Bool {
        let tested = TrafficLight( top : trafficLight.top, left : trafficLight.left, shape : trafficLight.shape )
        let action = fromAction( tested )
        
        action()
        
        for row in tested.contents.enumerated() {
            for col in row.element.enumerated() {
                if col.element.bulbType != .empty {
                    if row.offset + tested.top  >= contents.count        ||
                       col.offset + tested.left >= contents.first!.count ||
                       col.offset + tested.left <  0 {
                        // Beyond Well Bounds
                        return true
                    } else if contents[ row.offset ][ col.offset ].bulbType != .empty {
                        // Overlapping Another Bulb
                        return true
                    }
                }
            }
        }
        
        return false
    }
}
