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
    private( set ) var player : CKRecord! = nil
    private( set ) var leader : CKRecord! = nil
    
    // Externally accessible display name defaults to "Anonymous" if not provided
    internal var displayName : String! {
        get { return player[ .displayName ] as? String ?? "Anonymous" }
        
        set {
            player[ .displayName ] = newValue
            leader[ .displayName ] = newValue
            
            // Since this can be set from within another thread, dispatch
            // updates on the main thread
            DispatchQueue.main.async {
                self.delegate.displayName.text = self.displayName
                self.delegate.player( self, displayNameDidChangeTo : self.displayName )
            }
            
            delegate.container.publicCloudDatabase.save( player ) { _, _ in }
            delegate.container.publicCloudDatabase.save( leader ) { _, _ in }
        }
    }
    
    // Externally accessible avatar name defaults to global fallback if not provided
    internal var  avatar      : Avatar! {
        get { return ( Avatar.decodeFrom( player[ .avatar ] as? Data ) ?? Avatar.current ) }
        
        set {
            player[ .avatar ] = newValue.encoded
            leader[ .avatar ] = newValue.encoded
            
            // Since this can be set from within another thread, dispatch
            // updates on the main thread
            DispatchQueue.main.async {
                self.delegate.avatar.image = self.avatar.image
                self.delegate.player( self, avatarDidChangeTo : self.avatar )
            }
            
            delegate.container.publicCloudDatabase.save( player ) { _, _ in }
            delegate.container.publicCloudDatabase.save( leader ) { _, _ in }
        }
    }
    
    // Externally accessible avatar name, defaults to 0 if not provided
    internal var topScore    : Int! {
        get { return player[ .topScore    ] as? Int ?? 0 }
        
        set {
            player[ .topScore ] = newValue
            leader[ .topScore ] = newValue
            
            delegate.container.publicCloudDatabase.save( player ) { _, _ in }
            delegate.container.publicCloudDatabase.save( leader ) { _, _ in }
            
            // Query for leaderboard entry for the player
            let pred  = NSPredicate( value : true )
            let sort  = NSSortDescriptor( key : CloudKitRecord.topScore.description, ascending : false )
            let query = CKQuery( recordType : CloudKitRecord.Leaders.description, predicate : pred )
            
            query.sortDescriptors = [ sort ]
            
            // Retrieve the player's leaderboard entry, if any
            delegate.container.publicCloudDatabase.perform( query, inZoneWith: nil ) { records, error in
                guard let records = records, error == nil else { return }
                
                let matching = records.enumerated().filter {
                    $0.element[ CloudKitRecord.playerID.description ] == self.player.recordID.recordName
                }.first
                
                DispatchQueue.main.async {
                    self.delegate.placing.image = Placing.forPositionOf( matching?.offset ?? -1 ).image
                }
            }
        }
    }
    
    // Initializers
    
    init( delegate : PlayerDelegate, id : CKRecord.ID ) {
        self.delegate = delegate
        
        // Retrieve the user record with the provided ID
        delegate.container.publicCloudDatabase.fetch( withRecordID : id ) { record, error in
            guard let record = record, error == nil else {
                DispatchQueue.main.async { delegate.playerDidNotLoad( self ) }
                
                return
            }
            
            self.player               = record
            
            DispatchQueue.main.async {
                delegate.displayName.text = self.displayName
                delegate.avatar.image     = self.avatar.image
                
                delegate.playerDidLoad( self )
            }
            
            // Query for leaderboard entry for the player
            let pred  = NSPredicate( value : true )
            let sort  = NSSortDescriptor( key : CloudKitRecord.topScore.description, ascending : false )
            let query = CKQuery( recordType : CloudKitRecord.Leaders.description, predicate : pred )
            
            query.sortDescriptors = [ sort ]
            
            // Retrieve the player's leaderboard entry, if any
            delegate.container.publicCloudDatabase.perform( query, inZoneWith: nil ) { records, error in
                guard let records = records, error == nil else { return }
                
                let matching = records.enumerated().filter {
                    $0.element[ CloudKitRecord.playerID.description ] == self.player.recordID.recordName
                }.first
                
                // Create a new leaderboard entry if none was found
                self.leader = matching?.element ?? {
                    let newleader = CKRecord( recordType : CloudKitRecord.Leaders.description )
                    
                    newleader[ .playerID    ] = self.player.recordID.recordName
                    newleader[ .displayName ] = self.displayName
                    newleader[ .avatar      ] = self.avatar.encoded
                    newleader[ .topScore    ] = self.topScore
                    
                    delegate.container.publicCloudDatabase.save( newleader ) { _, _ in }
                    
                    return newleader
                }()
                
                DispatchQueue.main.async {
                    delegate.placing.image = Placing.forPositionOf( matching?.offset ?? -1 ).image
                }
            }
        }
    }
    
    // Methods
}
