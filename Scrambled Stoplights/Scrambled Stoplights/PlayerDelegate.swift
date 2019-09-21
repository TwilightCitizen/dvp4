/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit

protocol PlayerDelegate {
    // Required Properties
    
    var displayName : UILabel!     { get set }
    var avatar      : UIImageView! { get set }
    
    // Required Methods
    
    // Optional Methods
    
    func player( _ player : Player, displayNameDidChangeTo newName   : String )
    func player( _ player : Player, avatarDidChangeTo      newAvatar : Avatar )
}

extension PlayerDelegate {
    func player( _ player : Player, displayNameDidChangeTo newName   : String ) {}
    func player( _ player : Player, avatarDidChangeTo      newAvatar : Avatar ) {}
}
