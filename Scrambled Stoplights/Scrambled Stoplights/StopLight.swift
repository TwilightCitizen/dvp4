/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

class StopLight {
    // Properties
    
    private( set ) var bulbs    : [ Bulb ]
    private( set ) var shape    : BendAndRotation
    internal       var contents : [ [ Bulb ] ] { return shape.ofBulbs( bulbs ) }
    internal       var ghost    : StopLight    { return StopLight( top : top, left : left, shape : shape, asGhost : true ) }
    private( set ) var top      : Int
    private( set ) var left     : Int
    
    // Intitializers
    
    init( top : Int, left : Int, shape : BendAndRotation? = nil, asGhost : Bool = false ) {
        self.top   = top
        self.left  = left
        self.shape = shape ?? BendAndRotation.allCases.randomElement()!
        
        if asGhost {
            self.bulbs = [ Bulb( ofType : .ghost ), Bulb( ofType : .ghost ), Bulb( ofType : .ghost ) ]
        } else {
            self.bulbs = [
                Bulb( ofType : .stop, withWeight : BulbWeight.random ),
                Bulb( ofType : .slow, withWeight : BulbWeight.random ),
                Bulb( ofType : .go,   withWeight : BulbWeight.random )
            ].shuffled()
        }
    }
    
    // Methods
    
    func cycleUp()       { bulbs = Array( bulbs.dropFirst() ) + [ bulbs.first! ] }
    func cycleDown()     { bulbs = [ bulbs.last! ] + Array( bulbs.dropLast() )   }
    
    func rotateCounter() { shape = shape.next     }
    func rotateClock()   { shape = shape.previous }
    
    func moveLeft()      { left  = left - 1 }
    func moveRight()     { left  = left + 1 }
    
    func dropDown()      { top   = top + 1  }
}
