/* David Clark
 * MDV3730-O
 * Multipeer Connectivity Project 5.2
 * 2019-08-11
 */

import Foundation
import UIKit

enum Placing : String, CaseIterable, Codeable, Specifiable {
    // Cases
    
    case number1, number2, number3, top10, top25, top50, top100, notPlaced
    
    // Properties
    
    static let key       = CodeableKey.placing
    
    // Avatar is not globally specified, but all instances fallback to Grin
    static var specified : Placing? = nil
    static var fallback  : Placing  { return .notPlaced }
    
    var description      : String  { return self.rawValue }
    
    // Image is Avatar's string representation into assets.
    var image   : UIImage { return UIImage( named : rawValue )!    }
    
    static func forPositionOf( _ position : Int ) -> Placing {
        switch position + 1 {
        case 1        : return .number1
        case 2        : return .number2
        case 3        : return .number3
        case 4...10   : return .top10
        case 11...25  : return .top25
        case 26...50  : return .top50
        case 51...100 : return .top100
        default       : return .notPlaced
        }
    }
}
