/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

// Weights that a Bulb can have
enum BulbWeight : Int, CustomStringConvertible {
    // Cases
    
    case one
    case two
    case three
    
    // Properties
    
    // Convert from zero-based integer case to one-based numeric string
    var description   : String     { return ( self.rawValue + 1 ).description }
    
    // Random bulb weight has high probability for one, medium probability for
    // two, and low probability for three
    static var random : BulbWeight {
        switch ( 0...99 ).randomElement()! {
            case  0...49 : return .one
            case 50...84 : return .two
            case 85...99 : return .three
            default      : return .one
        }
    }
}
