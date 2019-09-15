/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import UIKit

class GameScreen : UIViewController {
    // Outlets
    
    @IBOutlet      var roundAllCorners    : [ UIView ]!
    @IBOutlet      var roundTopCorners    : [ UIView ]!
    @IBOutlet      var roundBottomCorners : [ UIView ]!
    @IBOutlet      var roundOuterCorners  : [ UIImageView ]!
    
    @IBOutlet weak var screenWell           : UIView!
    
    // Properties
    
    private        var controlRepeater      : SimpleRepeater!
    private        var gameRepeater         : SimpleRepeater!
    private        var gameWell             : GameWell!
    
    // Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCorners()
        
        gameWell = GameWell( matching : screenWell )
        
        gameWell.addTrafficLight( TrafficLight() )
        
        gameRepeater = SimpleRepeater( every : slowRepeat )
        
        gameRepeater.Start { self.gameWell.drawTo( screenWell : self.screenWell ) }
    }
    
    override func viewWillAppear( _ animated : Bool ) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func prepare( for segue : UIStoryboardSegue, sender : Any? ) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func roundCorners() {
        roundAllCorners.forEach                              { $0.round() }
        roundTopCorners.forEach                              { $0.round( corners : [ Corners.topLeft,    Corners.topRight    ] ) }
        roundBottomCorners.forEach                           { $0.round( corners : [ Corners.bottomLeft, Corners.bottomRight ] ) }
        zip( roundOuterCorners, Corners.allCorners ).forEach { ( view, corner ) in view.round( corners: [ corner ] ) }
    }
    
    @IBAction func seeLeaderboardTapped( _ sender : UIButton ) {
    }
    
    @IBAction func seeSettingsTapped(    _ sender : UIButton ) {
    }
    
    @IBAction func playPauseGameTapped(  _ sender : UIButton ) {
    }
    
    @IBAction func pinchInWell(          _ sender : UIPinchGestureRecognizer ) {
        guard sender.state == .ended else { return }
        
        if sender.scale > 1 {
            gameWell.cycleUp()
        } else {
            gameWell.cycleDown()
        }
    }
    
    @IBAction func cycleUpTapped(        _ sender : UIButton ) {
        gameWell.cycleUp()
    }
    
    @IBAction func cycleUpHeld(          _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { self.gameWell.cycleUp() }
    }
    
    @IBAction func cycleDownTapped(      _ sender : UIButton ) {
        gameWell.cycleDown()
    }
    
    @IBAction func cycleDownHeld(        _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { self.gameWell.cycleDown() }
    }
    
    @IBAction func rotatedInWell(        _ sender : UIRotationGestureRecognizer  ) {
        guard sender.state == .ended else { return }

        if sender.rotation < 0 {
            gameWell.rotateCounter()
        } else {
            gameWell.rotateClock()
        }
    }
    
    @IBAction func rotateCounterTapped(  _ sender : UIButton ) {
        gameWell.rotateCounter()
    }
    
    @IBAction func rotateCounterHeld(    _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { self.gameWell.rotateCounter() }
    }
    
    @IBAction func rotateClockTapped(    _ sender : UIButton ) {
        gameWell.rotateClock()
    }
    
    @IBAction func rotateClockHeld(      _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { self.gameWell.rotateClock() }
    }
    
    @IBAction func swipeLeftInWell(      _ sender : UISwipeGestureRecognizer     ) {
        gameWell.moveLeft()
    }
    
    @IBAction func swipeRightInWell(     _ sender : UISwipeGestureRecognizer     ) {
        gameWell.moveRight()
    }
    
    @IBAction func swipeDownInWell(      _ sender : UISwipeGestureRecognizer     ) {
        gameWell.dropDown()
    }
    
    @IBAction func moveLeftTapped(       _ sender : UIButton ) {
        gameWell.moveLeft()
    }
    
    @IBAction func moveLeftHeld(         _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { self.gameWell.moveLeft() }
    }
    
    @IBAction func moveRightTapped(      _ sender : UIButton ) {
        gameWell.moveRight()
    }
    
    @IBAction func moveRightHeld(        _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { self.gameWell.moveRight() }
    }
    
    @IBAction func dropDownTapped(       _ sender : UIButton ) {
        gameWell.dropDown()
    }
    
    @IBAction func dropDownHeld(         _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { self.gameWell.dropDown() }
    }
    
    func whileHolding( _ sender : UILongPressGestureRecognizer, repeatAction action : ( () -> Void )? = nil ) {
        switch sender.state {
            case .began :
                controlRepeater = SimpleRepeater( every : fastRepeat )
                
                controlRepeater.Start { if let action = action { action() } }
            
            default : controlRepeater.stop()
        }
    }
}

