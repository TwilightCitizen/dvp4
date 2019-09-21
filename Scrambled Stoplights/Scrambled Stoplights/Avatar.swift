/* David Clark
 * MDV3730-O
 * Multipeer Connectivity Project 5.2
 * 2019-08-11
 */

import Foundation
import UIKit

enum Avatar : String, CaseIterable, Codeable, Specifiable {
    // Cases
    
    case eye, lips, shades, angel, grin, army, nerd, champ, zombie, knight
    
    // Properties
    
    static let key       = CodeableKey.avatar
    
    // Avatar is not globally specified, but all instances fallback to Grin
    static var specified : Avatar? = nil
    static var fallback  : Avatar  { return .grin }
    
    var description      : String  { return self.rawValue }
    
    // Image is Avatar's string representation into assets.
    var image   : UIImage { return UIImage( named : rawValue )!    }
}
