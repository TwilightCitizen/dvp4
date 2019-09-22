/* David Clark
 * MDV3730-O
 * Multipeer Connectivity Project 5.2
 * 2019-08-11
 */

import Foundation
import CloudKit

class SignedInPlayer : Player {
    // Properties
    
    // Delegate responsible for functionality dependent on the player
    internal var delegate     : PlayerDelegate
    
    // Private fields for display name and avatar
    private var _displayName : String? = nil
    private var _avatar      : Avatar? = nil
    
    // ID of the signed in player
    private var id           : CKRecord.ID
    
    // Record of signed in user cached for easier updates
    private var record       : CKRecord! = nil
    
    // Top score of the signed in player
    private var _topScore    : Int? = nil
    
    // Externally accessible display name defaults to "Anonymous" if not provided
    internal var displayName : String! {
        get { return _displayName ?? "Anonymous" }
        
        set {
            _displayName              = newValue
            record[ .displayName ]    = newValue
            
            // Since this can be set from within another thread, dispatch
            // updates on the main thread
            DispatchQueue.main.async {
                self.delegate.displayName.text = self.displayName
                self.delegate.player( self, displayNameDidChangeTo : self.displayName )
            }
            
            delegate.container.publicCloudDatabase.save( record ) { _, _ in }
        }
    }
    
    // Externally accessible avatar name defaults to global fallback if not provided
    internal var  avatar      : Avatar! {
        get { return _avatar ?? Avatar.current }
        
        set {
            _avatar               = newValue
            record[ .avatar ]     = newValue.encoded
            
            // Since this can be set from within another thread, dispatch
            // updates on the main thread
            DispatchQueue.main.async {
                self.delegate.avatar.image = self.avatar.image
                self.delegate.player( self, avatarDidChangeTo : self.avatar )
            }
            
            delegate.container.publicCloudDatabase.save( record ) { _, _ in }
        }
    }
    
    // Externally accessible avatar name defaults to 0 if not provided
    internal var  topScore    : Int! {
        get { return _topScore ?? 0 }
        
        set {
            _topScore           = newValue
            record[ .topScore ] = newValue
            
            delegate.container.publicCloudDatabase.save( record ) { _, _ in }
        }
    }
    
    // Initializers
    
    init( delegate : PlayerDelegate, id : CKRecord.ID ) {
        self.delegate    = delegate
        self.id          = id
        
        // Retrieve the user record with the provided ID
        delegate.container.publicCloudDatabase.fetch( withRecordID : id ) { record, error in
            guard let record = record, error == nil else { return  }
            
            self.record      = record
            self.avatar      = Avatar.decodeFrom( record[ .avatar ] as? Data )
            self.displayName = record[ .displayName ] as? String
            self.topScore    = record[ .topScore    ] as? Int
        }
    }
    
    // Methods
}
