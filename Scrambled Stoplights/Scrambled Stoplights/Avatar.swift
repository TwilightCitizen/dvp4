/* David Clark
 * MDV3730-O
 * Multipeer Connectivity Project 5.2
 * 2019-08-11
 */

import Foundation
import UIKit

enum Avatar : String, CaseIterable, Specifiable, Codeable {
    // Cases
    
    case eye, lips, shades, angel, grin, army, nerd, champ, zombie, knight
    
    // Properties
    
    static let key       = CodeableKey.avatar
    
    // Specified theme is provided externally
    static var specified : Avatar? = nil
    
    // Fallback theme is first one, or classic
    static var fallback  : Avatar { return self.allCases.first! }
    
    var description      : String  { return self.rawValue }
    
    // Image is Avatar's string representation into assets.
    var image   : UIImage { return UIImage( named : rawValue )!    }
}
