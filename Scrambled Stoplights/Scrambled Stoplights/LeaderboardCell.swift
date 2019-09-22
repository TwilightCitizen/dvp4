/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import UIKit

class LeaderboardCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var placing     : UILabel!
    @IBOutlet weak var displayName : UILabel!
    @IBOutlet weak var topScore    : UILabel!
    
    // Properties
    
    // Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected( _ selected : Bool, animated : Bool ) {
        super.setSelected( selected, animated : animated )
    }
}
