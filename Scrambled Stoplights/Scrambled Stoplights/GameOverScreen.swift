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
    
    // Elements that need corners rounded
    @IBOutlet var roundAllCorners : [ UIView ]!
    
    // Required for reporting various game statistics after game over
    @IBOutlet weak var scoreLabel   : UILabel!
    @IBOutlet weak var clearsLabel  : UILabel!
    @IBOutlet weak var bestRunLabel : UILabel!
    
    // Properties
    
    // Game statistics passed in during segue from game screen
    var score   : Int!
    var clears  : Int!
    var bestRun : Int!
    
    // Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCorners()
        
        // Load the statistics into the "modal" view
        scoreLabel.text   = score.withCommas
        clearsLabel.text  = clears.withCommas
        bestRunLabel.text = bestRun.withCommas
    }
    
    func roundCorners() { roundAllCorners.forEach { $0.round() } }
    
    // Dismiss the game over screen when user taps outside of the "modal" region
    @IBAction func tappedOutsideOfModal( _ sender : UITapGestureRecognizer ) { dismiss( animated : true, completion : nil ) }
    
    // Dismiss the game over screen and segue to the leaderboard on behalf of the
    // game screen if the user taps the leaderboard button
    @IBAction func leaderboardTapped( _ sender : UIButton ) {
        let vc = presentingViewController!.children.last! as! GameScreen
        
        dismiss( animated : true ) { vc.performSegue( withIdentifier : Segue.gameToLeaderboard.description, sender : vc ) }
    }
}

