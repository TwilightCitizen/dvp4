/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

// Types that a Bulb can be.  This is much differentiated from the typical colors
// red, yellow, and green because the theme engine can provide different colors
// depending on the selected theme.
enum BulbType : String, CustomStringConvertible {
    // Cases
    
    case stop
    case slow
    case go
    case empty
    case clear
    case ghost
    
    // Properties
    
    var description : String  { return self.rawValue }
}
