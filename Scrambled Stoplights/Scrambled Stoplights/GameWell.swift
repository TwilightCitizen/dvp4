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
        
        if let light = trafficLight {
            trafficLight?.contents.enumerated().forEach { row in
                row.element.enumerated().forEach { col in
                    ( screenWell.subviews[ light.top + row.offset ].subviews[ light.left + col.offset ] as! UIImageView ).image =
                        trafficLight?.contents[ row.offset ][ col.offset ].image
                }
            }
        }
    }
    
    func addTrafficLight( _ trafficLight : TrafficLight ) {
        trafficLight.left = ( contents.first!.count - trafficLight.contents.first!.count ) / 2
        self.trafficLight = trafficLight
    }
}