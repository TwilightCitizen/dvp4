/* David Clark
 * MDV3730-O
 * Multipeer Connectivity Project 5.2
 * 2019-08-11
 */

import Foundation
import UIKit

enum Avatar : String, CaseIterable, Codeable {
    // Cases
    
    case eye, lips, shades, angel, grin, army, nerd, champ, zombie, knight
    
    // Properties
    
    static let key       = CodeableKey.avatar
    
    var description      : String  { return self.rawValue }
    
    // Image is Avatar's string representation into assets.
    var image   : UIImage { return UIImage( named : rawValue )!    }
}
