/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

// Stoplights are essentially bundles of nine bulbs, one each of stop, slow, and go surrounded
// by "empty" bulbs, filling out a 3x3 grid, or in the case of a ghost for showing where it
// will land in the Well, ghost bulbs feature instead of stop, slow, and go.
class StopLight {
    // Properties
    
    // Three primary bulbs, either stop, slow, and go, or all ghosts
    private( set ) var bulbs    : [ Bulb ]
    
    // Bend and/or rotation of the stoplight
    private( set ) var shape    : BendAndRotation
    
    // 3x3 grid of primary bulbs and empty bulbs, arranged according to bend and/or rotation
    internal       var contents : [ [ Bulb ] ] { return shape.ofBulbs( bulbs ) }
    
    // Mirror image of stoplight with primary bulbs replaced by ghost bulbs
    internal       var ghost    : StopLight    { return StopLight( top : top, left : left, shape : shape, asGhost : true ) }
    
    // Coordinates within any container
    private( set ) var top      : Int
    private( set ) var left     : Int
    
    // Intitializers
    
    init( top : Int, left : Int, shape : BendAndRotation? = nil, asGhost : Bool = false ) {
        // Set coordinates
        self.top   = top
        self.left  = left
        
        // Provide a random shape if none is given
        self.shape = shape ?? BendAndRotation.allCases.randomElement()!
        
        // Bulbs are either three ghosts or one each of stop, slow, and go, in random
        // order with random weights
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
    
    // Change the primary bulbs' order moving one end to the other and shifting
    // the remainig bulbs accordingly
    func cycleUp()       { bulbs = Array( bulbs.dropFirst() ) + [ bulbs.first! ] }
    func cycleDown()     { bulbs = [ bulbs.last! ] + Array( bulbs.dropLast() )   }
    
    // Bend and/or rotate cycles to the next or previous shape from current one
    func rotateCounter() { shape = shape.next     }
    func rotateClock()   { shape = shape.previous }
    
    // Move the left coordinate plus or minus 1 bulb
    func moveLeft()      { left  = left - 1 }
    func moveRight()     { left  = left + 1 }
    
    // Move the top coordinate plus 1 bulb
    func dropDown()      { top   = top + 1  }
}
