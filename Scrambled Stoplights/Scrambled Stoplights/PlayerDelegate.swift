/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit
import CloudKit

protocol PlayerDelegate {
    // Required Properties
    
    var displayName : UILabel!     { get set }
    var avatar      : UIImageView! { get set }
    var placing     : UIImageView! { get set }
    var container   : CKContainer  { get     }
    
    // Required Methods
    
    // Optional Methods
    
    func player( _ player : Player, displayNameDidChangeTo newName   : String )
    func player( _ player : Player, avatarDidChangeTo      newAvatar : Avatar )
    func player( _ player : Player, topScoreDidChangeTo    newScore  : Int    )
    
    func playerDidLoad(    _ player : Player )
    func playerDidNotLoad( _ player : Player )
}

extension PlayerDelegate {
    func player( _ player : Player, displayNameDidChangeTo newName   : String ) {}
    func player( _ player : Player, avatarDidChangeTo      newAvatar : Avatar ) {}
    func player( _ player : Player, topScoreDidChangeTo    newScore  : Int    ) {}
    
    func playerDidLoad(    _ player : Player ) {}
    func playerDidNotLoad( _ player : Player ) {}
}
