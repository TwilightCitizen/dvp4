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
    
    // Record of signed in user cached for easier updates
    private var record       : CKRecord! = nil
    
    // Externally accessible display name defaults to "Anonymous" if not provided
    internal var displayName : String! {
        get { return record[ .displayName ] as? String ?? "Anonymous" }
        
        set {
            record[ .displayName ] = newValue
            
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
        get { return ( Avatar.decodeFrom( record[ .avatar ] as? Data ) ?? Avatar.current ) }
        
        set {
            record[ .avatar ] = newValue.encoded
            
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
        get { return record[ .topScore    ] as? Int ?? 0 }
        
        set {
            record[ .topScore ] = newValue
            
            delegate.container.publicCloudDatabase.save( record ) { _, _ in }
        }
    }
    
    // Initializers
    
    init( delegate : PlayerDelegate, id : CKRecord.ID ) {
        self.delegate    = delegate
        
        // Retrieve the user record with the provided ID
        delegate.container.publicCloudDatabase.fetch( withRecordID : id ) { record, error in
            guard let record = record, error == nil else {
                DispatchQueue.main.async { delegate.playerDidNotLoad( self ) }
                
                return
           }
            
            self.record               = record
            
            DispatchQueue.main.async {
                delegate.displayName.text = self.displayName
                delegate.avatar.image     = self.avatar.image
                
                delegate.playerDidLoad( self )
            }
        }
    }
    
    // Methods
}
