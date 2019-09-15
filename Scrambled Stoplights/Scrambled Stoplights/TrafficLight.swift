/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

class TrafficLight {
    // Properties
    
    private lazy var bulbs = {
        return [
            Bulb( ofType : .stop, withWeight : BulbWeight.random ),
            Bulb( ofType : .slow, withWeight : BulbWeight.random ),
            Bulb( ofType : .go,   withWeight : BulbWeight.random )
        ].shuffled()
    }()
    
    private lazy var shape = { return BendAndRotation.allCases.randomElement()! }()
    
                 var contents : [ [ Bulb ] ] { return shape.ofBulbs( bulbs ) }
    
                 var top   = -3
                 var left  = 0
    
    // Intitializers
    
    // Methods
    
    func cycleUp()       { bulbs = Array( bulbs.dropFirst() ) + [ bulbs.first! ] }
    func cycleDown()     { bulbs = [ bulbs.last! ] + Array( bulbs.dropLast() )   }
    
    func rotateCounter() { shape = shape.next     }
    func rotateClock()   { shape = shape.previous }
    
    func moveLeft()      { left  = left - 1 }
    func moveRight()     { left  = left + 1 }
    
    func dropDown()      { top   = top + 1  }
}
