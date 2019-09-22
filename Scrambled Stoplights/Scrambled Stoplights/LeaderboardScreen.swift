/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import UIKit
import CloudKit

class LeaderboardScreen : UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Outlets
    @IBOutlet weak var tableView : UITableView!
    
    // Properties
    
    internal var container : CKContainer!
    internal var player    : Player!
    private  var leaders   : [ CKRecord ]!
    private  var placing   : Int?
    
    // Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .darkGray
        
        // Query for leaderboard entries
        let pred  = NSPredicate( format: "topScore > \( 0 )" )
        let sort  = NSSortDescriptor( key : CloudKitRecord.topScore.description, ascending : false )
        let query = CKQuery( recordType : CloudKitRecord.Leaders.description, predicate : pred )
        
        query.sortDescriptors = [ sort ]
        
        // Retrieve leaderboard entries, if any
        container.publicCloudDatabase.perform( query, inZoneWith: nil ) { records, error in
            guard let records = records, error == nil else { return }
            
            // Hook up to the table.
            self.leaders = records
            
            // See if the player is placed for selection
            if let signedIn = self.player as? SignedInPlayer {
                let matched = records.enumerated().filter {
                    $0.element[ CloudKitRecord.playerID.description ] == signedIn.player.recordID.recordName
                }.first
                
                self.placing = matched?.offset
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
                if let placing = self.placing { self.tableView.selectRow(
                    at : IndexPath( row : placing, section : 0 ), animated : true, scrollPosition : .middle
                ) }
            }
        }
    }
    
    func tableView( _ tableView : UITableView, numberOfRowsInSection section : Int ) -> Int {
        // One row for each leader, but none until loaded from iCloud
        return leaders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView( _ tableView : UITableView, cellForRowAt indexPath : IndexPath ) -> UITableViewCell {
        if let cell    = tableView.dequeueReusableCell( withIdentifier : ReusableCell.leader.description ) as? LeaderboardCell {
            let leader = leaders[ indexPath.row ]
            
            cell.placing.text     = ( indexPath.row + 1 ).withCommas
            cell.displayName.text = leader[ .displayName ] as? String
            cell.topScore.text    = ( leader[ .topScore ] as? Int )?.withCommas
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView( _ tableView : UITableView, willDisplay cell : UITableViewCell, forRowAt indexPath : IndexPath ) {
        if let cell = cell as? LeaderboardCell, indexPath.row == placing {
            cell.contentView.backgroundColor = .yellow
            cell.placing.textColor           = .darkGray
            cell.displayName.textColor       = .darkGray
            cell.topScore.textColor          = .darkGray
        }
    }
}
