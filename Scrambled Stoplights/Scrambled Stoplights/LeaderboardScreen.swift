/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import UIKit

class LeaderboardScreen : UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Outlets
    
    // Properties
    
    // Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView( _ tableView : UITableView, numberOfRowsInSection section : Int ) -> Int {
        return 1
    }
    
    func tableView( _ tableView : UITableView, cellForRowAt indexPath : IndexPath ) -> UITableViewCell {
        return UITableViewCell()
    }
}
