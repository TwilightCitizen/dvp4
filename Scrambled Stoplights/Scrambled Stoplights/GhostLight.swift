/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

class GhostLight {
    // Properties
    
    private( set )      var bulbs = [ Bulb( ofType : .ghost ), Bulb( ofType : .ghost ), Bulb( ofType : .ghost ) ]
    private( set )      var shape    : BendAndRotation
    var contents : [ [ Bulb ] ] { return shape.ofBulbs( bulbs ) }
    private( set )      var top  : Int
    private( set )      var left : Int
    
    // Intitializers
    
    init( top : Int, left : Int, shape : BendAndRotation? = nil ) {
        self.top   = top
        self.left  = left
        self.shape = shape ?? BendAndRotation.allCases.randomElement()!
    }
    
    // Methods
    
    func dropDown() { top   = top + 1  }
}
