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
    @IBOutlet var roundAllCorners    : [ UIView ]!
    @IBOutlet var roundTopCorners    : [ UIView ]!
    @IBOutlet var roundBottomCorners : [ UIView ]!
    
    // Properties
    
    private   var repeater           : SimpleRepeater!
    
    // Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCorners()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    func roundCorners() {
        roundAllCorners.forEach    { $0.round() }
        roundTopCorners.forEach    { $0.round( corners : [ Corners.topLeft,    Corners.topRight    ] ) }
        roundBottomCorners.forEach { $0.round( corners : [ Corners.bottomLeft, Corners.bottomRight ] ) }
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
            print( "Cycle Up Tapped"   )
        } else {
            print( "Cycle Down Tapped" )
        }
    }
    
    @IBAction func cycleUpTapped(        _ sender : UIButton ) {
        print( "Cycle Up Tapped" )
    }
    
    @IBAction func cycleUpHeld(          _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { print( "Cycle Up Tapped" ) }
    }
    
    @IBAction func cycleDownTapped(      _ sender : UIButton ) {
        print( "Cycle Down Tapped" )
    }
    
    @IBAction func cycleDownHeld(        _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { print( "Cycle Down Tapped" ) }
    }
    
    @IBAction func rotatedInWell(        _ sender : UIRotationGestureRecognizer  ) {
        guard sender.state == .ended else { return }

        if sender.rotation < 0 {
            print( "Rotate Counter Tapped" )
        } else {
            print( "Rotate Clock Tapped" )
        }
    }
    
    @IBAction func rotateCounterTapped(  _ sender : UIButton ) {
        print( "Rotate Counter Tapped" )
    }
    
    @IBAction func rotateCounterHeld(    _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { print( "Rotate Counter Tapped" ) }
    }
    
    @IBAction func rotateClockTapped(    _ sender : UIButton ) {
        print( "Rotate Clock Tapped" )
    }
    
    @IBAction func rotateClockHeld(      _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { print( "Rotate Clock Tapped" ) }
    }
    
    @IBAction func swipeLeftInWell(      _ sender : UISwipeGestureRecognizer     ) {
        print( "Move Left Tapped" )
    }
    
    @IBAction func swipeRightInWell(     _ sender : UISwipeGestureRecognizer     ) {
        print( "Move Right Tapped" )
    }
    
    @IBAction func swipeDownInWell(      _ sender : UISwipeGestureRecognizer     ) {
        print( "Drop Down Tapped" )
    }
    
    @IBAction func moveLeftTapped(       _ sender : UIButton ) {
        print( "Move Left Tapped" )
    }
    
    @IBAction func moveLeftHeld(         _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { print( "Move Left Tapped" ) }
    }
    
    @IBAction func moveRightTapped(      _ sender : UIButton ) {
        print( "Move Right Tapped" )
    }
    
    @IBAction func moveRightHeld(        _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { print( "Move Right Tapped" ) }
    }
    
    @IBAction func dropDownTapped(       _ sender : UIButton ) {
        print( "Drop Down Tapped" )
    }
    
    @IBAction func dropDownHeld(         _ sender : UILongPressGestureRecognizer ) {
        whileHolding( sender ) { print( "Drop Down Tapped" ) }
    }
    
    func whileHolding( _ sender : UILongPressGestureRecognizer, repeatAction action : ( () -> Void )? = nil ) {
        switch sender.state {
            case .began :
                repeater = SimpleRepeater( every : repeatInterval )
                
                repeater.Start { if let action = action { action() } }
            
            default : repeater.stop()
        }
    }
}

