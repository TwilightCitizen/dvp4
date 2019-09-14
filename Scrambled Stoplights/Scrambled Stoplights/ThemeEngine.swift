/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit

enum Theme : String, CustomStringConvertible {
    // Cases
    
    case classic
    case protanopia
    case deuteranopia
    case tritanopia
    case monochromatic
    case ps4controller
    
    // Properties
    
    static var current : Theme = .classic
    
    var description : String  { return self.rawValue }
}
