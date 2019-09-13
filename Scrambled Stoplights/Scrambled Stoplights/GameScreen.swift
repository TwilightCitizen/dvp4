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
    @IBOutlet var roundAllCorners   : [ UIView ]!
    @IBOutlet var roundTopCorners   : [ UIView ]!
    @IBOutlet var roundBottomCorners: [ UIView ]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCorners()
    }
    
    func roundCorners() {
        roundAllCorners.forEach    { $0.round() }
        roundTopCorners.forEach    { $0.round( corners : [ Corners.topLeft,    Corners.topRight    ] ) }
        roundBottomCorners.forEach { $0.round( corners : [ Corners.bottomLeft, Corners.bottomRight ] ) }
    }
}

