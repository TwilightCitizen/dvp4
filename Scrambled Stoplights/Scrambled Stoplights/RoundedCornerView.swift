/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit

struct Corners {
    // Properties
    
    static let topLeft     = CACornerMask.layerMinXMinYCorner
    static let topRight    = CACornerMask.layerMaxXMinYCorner
    static let bottomLeft  = CACornerMask.layerMinXMaxYCorner
    static let bottomRight = CACornerMask.layerMaxXMaxYCorner
    
    static let allCorners  = [ topLeft, topRight, bottomRight, bottomLeft ]
}

extension UIView {
    // Methods
    
    func round(
        corners         : CACornerMask = CACornerMask( Corners.allCorners ),
        toRadius radius : CGFloat      = cornerRadius
    ) {
        self.layer.cornerRadius        = radius
        self.layer.maskedCorners       = corners
    }
}
