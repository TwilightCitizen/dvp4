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
    
                 var top   =  0
                 var left  = 0
    
    // Intitializers
    
    // Methods
}
