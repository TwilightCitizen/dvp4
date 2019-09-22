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
    private  var leaders   : [ CKRecord ]!
    
    // Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Query for leaderboard entries
        let pred  = NSPredicate( value: true )
        let sort  = NSSortDescriptor( key : CloudKitRecord.topScore.description, ascending : false )
        let query = CKQuery( recordType : CloudKitRecord.Leaders.description, predicate : pred )
        
        query.sortDescriptors = [ sort ]
        
        // Retrieve leaderboard entries, if any
        container.publicCloudDatabase.perform( query, inZoneWith: nil ) { records, error in
            guard let records = records, error == nil else { return }
            
            // Hook up to the table.
            self.leaders = records
            
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
    
    func tableView( _ tableView : UITableView, numberOfRowsInSection section : Int ) -> Int {
        return leaders?.count ?? 0
    }
    
    func tableView( _ tableView : UITableView, cellForRowAt indexPath : IndexPath ) -> UITableViewCell {
        if let cell    = tableView.dequeueReusableCell( withIdentifier : ReusableCell.leader.description ) {
            let leader = leaders[ indexPath.row ]
            
            cell.textLabel?.text       = leader[ .displayName ] as? String
            cell.detailTextLabel?.text = ( leader[ .topScore ] as? Int )?.withCommas
            
            return cell
        }
        
        return UITableViewCell()
    }
}
