/* David Clark
 * MDV3730-O
 * Multipeer Connectivity Project 5.2
 * 2019-08-11
 */

import Foundation

class SignedInPlayer : Player {
    // Properties
    
    // Delegate responsible for functionality dependent on the player
    internal var delegate     : PlayerDelegate
    
    // Private fields for display name and avatar
    private var _displayName : String? = nil
    private var _avatar      : Avatar? = nil
    
    // ID of the signed in player
    private var id           : String
    
    // Externally accessible display name defaults to "Anonymous" if not provided
    internal var displayName : String! {
        get { return _displayName ?? "Anonymous" }
        
        set {
            _displayName              = newValue
            delegate.displayName.text = displayName
            
            delegate.player( self, displayNameDidChangeTo : displayName )
        }
    }
    
    // Externally accessible avatar name defaults to global fallback if not provided
    internal var  avatar      : Avatar! {
        get { return _avatar ?? Avatar.current }
        
        set {
            _avatar               = newValue
            delegate.avatar.image = avatar.image
            
            delegate.player( self, avatarDidChangeTo : avatar )
        }
    }
    
    // Initializers
    
    init( delegate : PlayerDelegate, id : String, displayName : String? = nil, avatar : Avatar? = nil ) {
        self.delegate    = delegate
        self.id          = id
        self.displayName = displayName
        self.avatar      = avatar
    }
    
    // Methods
}
