/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import UIKit
import CloudKit

class GameScreen : UIViewController, GameDelegate, PlayerDelegate {
    // Outlets
    
    // Elements that need corners rounded
    @IBOutlet      var roundAllCorners    : [ UIView ]!
    @IBOutlet      var roundTopCorners    : [ UIView ]!
    @IBOutlet      var roundBottomCorners : [ UIView ]!
    @IBOutlet      var roundOuterCorners  : [ UIImageView ]!
    
    @IBOutlet var goldBorders             : [ UIView ]!
    
    
    // Panels required by GameDelegate for certain game states
    @IBOutlet weak var well               : UIView!
    @IBOutlet weak var paused             : UIView!
    @IBOutlet weak var nogame             : UIView!
    
    // Required by GameDelegate for presenting StopLight Forecast
    @IBOutlet      var forecast           : [ UIView ]!
    
    // Required by GameDelegate for controlling game and to
    // enable or disable on certain game states
    @IBOutlet      var controls           : [ UIButton ]!
    
    // Dynamic image sits behind transparent button since
    // buttons fail to manage images well
    @IBOutlet weak var playPause          : UIImageView!
    
    // Required by GameDelegate for reporting various
    // game statistics as it runs
    @IBOutlet weak var score              : UILabel!
    @IBOutlet weak var clears             : UILabel!
    @IBOutlet weak var bestRun            : UILabel!
    
    // Required by PlayerDelegate for reporting player
    // display name and avatar
    @IBOutlet weak var displayName        : UILabel!
    @IBOutlet weak var avatar             : UIImageView!
    @IBOutlet weak var placing            : UIImageView!
    
    
    // Properties
    
    // The Game of Scrambled Stoplights - Could offer saving to
    // and loading from persistent storage in the future
    private( set ) var game               : Game!
    
    // Repeater for controls that are held down instead of tapped
    private        var repeater           : SimpleRepeater!
    
    // Player of the game
    internal       var player             : Player!
    
    internal       var container          = CKContainer.default()
    
    // Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCorners()
        colorBorders()
        setupGame()
        setupPlayer()
        
        // Look out for iCloud sign in and out while app is in use
        NotificationCenter.default.addObserver( self,
            selector : #selector( userChanged ),
            name     : Notification.Name.CKAccountChanged,
            object   : nil
        )
    }
    
    // Handle iCloud sign in and out by resetting game and user
    @objc func userChanged() {
        DispatchQueue.main.async {
            self.game.reset( silent : true )
            self.setupPlayer()
        }
    }
    
    override func viewWillAppear( _ animated : Bool ) {
        UIDevice.current.setValue( UIInterfaceOrientation.portrait.rawValue, forKey : "orientation" )
        (  UIApplication.shared.delegate as! AppDelegate ).orientation = .portrait
        
        let navbar = navigationController!.navigationBar
        
        // Format navigation bar
        navbar.barTintColor        = .darkGray
        
        navbar.titleTextAttributes = [
            .foregroundColor : UIColor.yellow,
            .font : UIFont( name : "Menlo", size : 16 )!
        ]
        
        navbar.tintColor          = UIColor.white
        
        // Hide navigation bar on the game screen
        navbar.isHidden            = true
    }
    
    override func viewWillDisappear( _ animated : Bool ) {
        (  UIApplication.shared.delegate as! AppDelegate ).orientation = .portrait
    }
    
    override func prepare( for segue : UIStoryboardSegue, sender : Any? ) {
        // Pause any running game first
        if game.running { game.stop() }
        
        // Show navigation bar by default, presently on the
        // leaderboard and settings screens
        navigationController?.navigationBar.isHidden = false
        
        switch segue.identifier {
            // Pass game statistics to game over screen on segue
            case Segue.gameToSettings.description :
                if let dest = segue.destination as? SettingsScreen {
                    dest.player    = player
                    dest.container = container
                }
            
            case Segue.gameToLeaderboard.description :
                if let dest = segue.destination as? LeaderboardScreen {
                    dest.player    = player
                    dest.container = container
                }
            
            default : ()
        }
    }
    
    func roundCorners() {
        roundAllCorners.forEach           { $0.round() }
        roundTopCorners.forEach           { $0.round( corners : [ Corners.topLeft,    Corners.topRight    ] ) }
        roundBottomCorners.forEach        { $0.round( corners : [ Corners.bottomLeft, Corners.bottomRight ] ) }
        
        // This relies on views added to outer corners being added in the
        // same order as the constants in the Corners struct of the view
        // extension for corner rounding - Concise but less clear than
        // adding each view to its own collection like "topLeftCorners"
        zip( roundOuterCorners,
             Corners.allCorners ).forEach { ( view, corner ) in view.round( corners: [ corner ] ) }
    }
    
    func colorBorders() {
        goldBorders.forEach { $0.layer.borderWidth = 1; $0.layer.borderColor = UIColor.yellow.cgColor }
    }
    
    func setupGame() {
        // Keep game in AppDelegate and refer to it from game screen
        // so app backgrounding can trigger game pausing
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.game = Game( delegate : self )
        game          = delegate.game
    }
    
    func setupPlayer() {
        container.fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                self.player = GuestPlayer( delegate : self )
                
                return
            }

            self.player = SignedInPlayer( delegate : self, id : recordID )
        }
    }
    
    // Swap the play/pause button image accordingly
    func gameDidStart( _ game : Game ) { playPause.image = UIImage( named : "Pause" ) }
    func gameDidStop(  _ game : Game ) { playPause.image = UIImage( named : "Play" ) }
    
    func game( _ game : Game, didEndWithScore score : Int, clears : Int, andBestRun best : Int ) {
        // Switch to game over screen when its... over
        // performSegue( withIdentifier : Segue.gameToGameOver.description, sender : self )
        
        var message : String
        
        if let signedIn = player as? SignedInPlayer {
            if score > signedIn.topScore {
                message           = "You bested your old top score of \( signedIn.topScore.withCommas ) points! " +
                                    "Your new top score is \( score.withCommas )! "
                
                signedIn.topScore = score
                
            } else {
                message = "You missed your top score, finishing with \( score.withCommas ) points! "
            }
            
        } else {
            message = "You finished with \( score.withCommas ) points! "
        }
        
        message += "You cleared \( clears.withCommas ) bulbs and " +
                   "your best run was \( best.withCommas ) clears in a row!"
        
        let alert = UIAlertController(
            title          : "Game Over!",
            message        : message,
            preferredStyle : .alert
        )
        
        let close        = UIAlertAction( title : "Close",             style : .cancel  ) { _ in }
        
        let leaderboard  = UIAlertAction( title : "View Leaderboard",  style : .default ) { _ in
            self.performSegue( withIdentifier : Segue.gameToLeaderboard.description, sender : self )
        }
        
        alert.addAction( close        )
        alert.addAction( leaderboard  )
        self.present( alert, animated : true, completion : nil )
    }
    
    // Subsequent actions mate game controls and gesture recognizers to
    // game actions, possibly repeated at fast interval if held not tapped
    
    @IBAction func playPauseGameTapped(  _ sender : UIButton ) { if game.running { game.stop() } else { game.start() } }
    @IBAction func resetGameTapped(      _ sender : UIButton ) { game.reset()                                          }
    
    @IBAction func cycleUpTapped(        _ sender : UIButton ) { game.cycleUp()       }
    @IBAction func cycleDownTapped(      _ sender : UIButton ) { game.cycleDown()     }
    @IBAction func rotateCounterTapped(  _ sender : UIButton ) { game.rotateCounter() }
    @IBAction func rotateClockTapped(    _ sender : UIButton ) { game.rotateClock()   }
    @IBAction func moveLeftTapped(       _ sender : UIButton ) { game.moveLeft()      }
    @IBAction func moveRightTapped(      _ sender : UIButton ) { game.moveRight()     }
    @IBAction func dropDownTapped(       _ sender : UIButton ) { game.dropDown()      }
    
    @IBAction func cycleUpHeld(          _ sender : UILongPressGestureRecognizer ) { whileHolding( sender ) { self.game.cycleUp()       } }
    @IBAction func cycleDownHeld(        _ sender : UILongPressGestureRecognizer ) { whileHolding( sender ) { self.game.cycleDown()     } }
    @IBAction func rotateCounterHeld(    _ sender : UILongPressGestureRecognizer ) { whileHolding( sender ) { self.game.rotateCounter() } }
    @IBAction func rotateClockHeld(      _ sender : UILongPressGestureRecognizer ) { whileHolding( sender ) { self.game.rotateClock()   } }
    @IBAction func moveLeftHeld(         _ sender : UILongPressGestureRecognizer ) { whileHolding( sender ) { self.game.moveLeft()      } }
    @IBAction func moveRightHeld(        _ sender : UILongPressGestureRecognizer ) { whileHolding( sender ) { self.game.moveRight()     } }
    @IBAction func dropDownHeld(         _ sender : UILongPressGestureRecognizer ) { whileHolding( sender ) { self.game.dropDown()      } }
    
    @IBAction func rotatedInWell(        _ sender : UIRotationGestureRecognizer  ) {
        guard sender.state == .ended else { return }

        // Rotation matches angle of arc from 0 degrees/radians
        if sender.rotation < 0 { game.rotateCounter() } else { game.rotateClock() }
    }
    
    @IBAction func pinchInWell(          _ sender : UIPinchGestureRecognizer ) {
        guard sender.state == .ended else { return }
        
        // Gesture equates to holding thumb on screen and flicking finger
        // up or down to cyle up or down accordingly
        if sender.scale > 1 { game.cycleUp() } else { game.cycleDown() }
    }
    
    @IBAction func swipeLeftInWell(      _ sender : UISwipeGestureRecognizer     ) { game.moveLeft()  }
    @IBAction func swipeRightInWell(     _ sender : UISwipeGestureRecognizer     ) { game.moveRight() }
    @IBAction func swipeDownInWell(      _ sender : UISwipeGestureRecognizer     ) { game.dropDown() }

    // Repeats an action at fast interval when a long press gesture recognizer (for a control ) is held down
    func whileHolding( _ sender : UILongPressGestureRecognizer, repeatAction action : ( () -> Void )? = nil ) {
        switch sender.state {
            // Start repeating when hold begins
            case .began :
                repeater = SimpleRepeater( every : fastInterval ) { if let action = action { action() } }
                
                repeater.start()
            
            // Otherwise, stop repeating
            default : repeater.stop()
        }
    }
}

