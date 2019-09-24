/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit

// Themes used throughout the game.  Themes concatenated with
// bulb type and bulb weight correspond to a specific bulb image
// for drawing to the game screen.
enum Theme : String, CaseIterable, Specifiable, Codeable {
    // Cases
    
    case classic
    case protanopia
    case deuteranopia
    case tritanopia
    case ps4controller
    
    // Properties
    
    static let key       =  CodeableKey.theme
    
    // Specified theme is provided externally
    static var specified : Theme? = nil
    
    // Fallback theme is first one, or classic
    static var fallback  : Theme  { return self.allCases.first! }
    
    var description      : String { return self.rawValue        }
}
