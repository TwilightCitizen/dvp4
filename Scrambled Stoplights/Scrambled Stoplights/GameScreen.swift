/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import UIKit

class GameScreen : UIViewController, GameDelegate {
    // Outlets
    
    @IBOutlet      var roundAllCorners    : [ UIView ]!
    @IBOutlet      var roundTopCorners    : [ UIView ]!
    @IBOutlet      var roundBottomCorners : [ UIView ]!
    @IBOutlet      var roundOuterCorners  : [ UIImageView ]!
    
    @IBOutlet weak var well               : UIView!
    @IBOutlet weak var paused             : UIView!
    
    @IBOutlet var forecast                : [ UIView ]!
    
    @IBOutlet var controls                : [ UIButton ]!
    
    @IBOutlet weak var playPause          : UIImageView!
    
    @IBOutlet weak var score              : UILabel!
    @IBOutlet weak var clears             : UILabel!
    @IBOutlet weak var bestRun            : UILabel!
    
    // Properties
    
    private( set ) lazy var game          : Game = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.game = Game( delegate : self )
        
        return delegate.game
    }()
    
    private        var repeater           = SimpleRepeater( every : fastInterval )
    
    // Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCorners()
    }
    
    override func viewWillAppear( _ animated : Bool ) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func prepare( for segue : UIStoryboardSegue, sender : Any? ) {
        navigationController?.navigationBar.isHidden = false
        
        game.stop()
    }
    
    func roundCorners() {
        roundAllCorners.forEach                              { $0.round() }
        roundTopCorners.forEach                              { $0.round( corners : [ Corners.topLeft,    Corners.topRight    ] ) }
        roundBottomCorners.forEach                           { $0.round( corners : [ Corners.bottomLeft, Corners.bottomRight ] ) }
        zip( roundOuterCorners, Corners.allCorners ).forEach { ( view, corner ) in view.round( corners: [ corner ] ) }
    }
    
    func gameDidStart( _ game : Game ) { playPause.image = UIImage( named : "Pause" ) }
    func gameDidStop(  _ game : Game ) { playPause.image = UIImage( named : "Play" ) }
    
    func game( _ game : Game, didEndWithScore score : Int ) {
        repeater.stop()
        
        let alert = UIAlertController( title : "Game Over", message : "Nice job!  You scored \( score ) points!", preferredStyle : .alert )
        
        alert.addAction( UIAlertAction( title : "OK", style : .default, handler : nil ) )
        
        present( alert, animated : true )
    }
    
    @IBAction func seeLeaderboardTapped( _ sender : UIButton ) {}
    
    @IBAction func seeSettingsTapped(    _ sender : UIButton ) {}
    
    @IBAction func playPauseGameTapped(  _ sender : UIButton ) {
        if game.running { game.stop() } else { game.start() }
    }
    
    @IBAction func pinchInWell(          _ sender : UIPinchGestureRecognizer ) {
        guard sender.state == .ended else { return }
        
        if sender.scale > 1 { game.cycleUp() } else { game.cycleDown() }
    }
    
    @IBAction func cycleUpTapped(        _ sender : UIButton ) {
        game.cycleUp()
    }
    
    @IBAction func cycleUpHeld(          _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { self.game.cycleUp() }
    }
    
    @IBAction func cycleDownTapped(      _ sender : UIButton ) {
        game.cycleDown()
    }
    
    @IBAction func cycleDownHeld(        _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { self.game.cycleDown() }
    }
    
    @IBAction func rotatedInWell(        _ sender : UIRotationGestureRecognizer  ) {
        guard sender.state == .ended else { return }

        if sender.rotation < 0 { game.rotateCounter() } else { game.rotateClock() }
    }
    
    @IBAction func rotateCounterTapped(  _ sender : UIButton ) {
        game.rotateCounter()
    }
    
    @IBAction func rotateCounterHeld(    _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { self.game.rotateCounter() }
    }
    
    @IBAction func rotateClockTapped(    _ sender : UIButton ) {
        game.rotateClock()
    }
    
    @IBAction func rotateClockHeld(      _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { self.game.rotateClock() }
    }
    
    @IBAction func swipeLeftInWell(      _ sender : UISwipeGestureRecognizer     ) {
        game.moveLeft()
    }
    
    @IBAction func swipeRightInWell(     _ sender : UISwipeGestureRecognizer     ) {
        game.moveRight()
    }
    
    @IBAction func swipeDownInWell(      _ sender : UISwipeGestureRecognizer     ) {
        game.dropDown()
    }
    
    @IBAction func moveLeftTapped(       _ sender : UIButton ) {
        game.moveLeft()
    }
    
    @IBAction func moveLeftHeld(         _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { self.game.moveLeft() }
    }
    
    @IBAction func moveRightTapped(      _ sender : UIButton ) {
        game.moveRight()
    }
    
    @IBAction func moveRightHeld(        _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { self.game.moveRight() }
    }
    
    @IBAction func dropDownTapped(       _ sender : UIButton ) {
        game.dropDown()
    }
    
    @IBAction func dropDownHeld(         _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { self.game.dropDown() }
    }
    
    func whileHolding( _ sender : UILongPressGestureRecognizer, repeatAction action : ( () -> Void )? = nil ) {
        switch sender.state {
            case .began :
                repeater = SimpleRepeater( every : fastInterval )
                
                repeater.start { if let action = action { action() } }
            
            default : repeater.stop()
        }
    }
}

