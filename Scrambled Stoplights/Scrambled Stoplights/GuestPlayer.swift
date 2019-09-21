/* David Clark
 * MDV3730-O
 * Multipeer Connectivity Project 5.2
 * 2019-08-11
 */

import Foundation

class GuestPlayer : Player {
    // Properties
    
    // Delegate responsible for functionality dependent on the player
    internal var delegate    : PlayerDelegate
    
    // Externally accessible display name required to be "Guest"
    internal let displayName : String! = "Guest"
    
    // Externally accessible avatar name required to be global fallback
    internal let avatar      : Avatar! = Avatar.current
    
    // Initializers
    
    init( delegate : PlayerDelegate ) {
        self.delegate = delegate
        
        delegate.player( self, displayNameDidChangeTo : displayName )
        delegate.player( self, avatarDidChangeTo      : avatar      )
        
        delegate.displayName.text = displayName
        delegate.avatar.image     = avatar.image
    }
    
    // Methods
}
