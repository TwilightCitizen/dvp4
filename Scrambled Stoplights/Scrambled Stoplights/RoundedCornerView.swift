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
    static let topLeft     = CACornerMask.layerMinXMinYCorner
    static let topRight    = CACornerMask.layerMaxXMinYCorner
    static let bottomLeft  = CACornerMask.layerMinXMaxYCorner
    static let bottomRight = CACornerMask.layerMaxXMaxYCorner
}

extension UIView {
    func round(
        corners : CACornerMask = [
            Corners.topLeft,
            Corners.topRight,
            Corners.bottomLeft,
            Corners.bottomRight
        ],
        
        toRadius radius : CGFloat = cornerRadius
    ) {
        self.layer.cornerRadius  = radius
        self.layer.maskedCorners = corners
    }
}
