/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import UIKit

class GameOverScreen : UIViewController {
    // Outlets
    
    @IBOutlet var roundAllCorners : [ UIView ]!
    
    @IBOutlet weak var scoreLabel   : UILabel!
    @IBOutlet weak var clearsLabel  : UILabel!
    @IBOutlet weak var bestRunLabel : UILabel!
    
    // Properties
    
    var score   : Int!
    var clears  : Int!
    var bestRun : Int!
    
    // Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCorners()
        
        scoreLabel.text   = score.withCommas
        clearsLabel.text  = clears.withCommas
        bestRunLabel.text = bestRun.withCommas
    }
    
    func roundCorners() { roundAllCorners.forEach { $0.round() } }
    
    @IBAction func tappedOutsideOfModal( _ sender : UITapGestureRecognizer ) {
        dismiss( animated : true, completion : nil )
    }
}

