/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit

protocol GameDelegate {
    // Required Properties
    
    var well    : UIView!  { get set }
    var score   : UILabel! { get set }
    var clears  : UILabel! { get set }
    var bestRun : UILabel! { get set }
    
    // TODO: Require a forecast of type [ UIView ]! where forecasted pieces can be drawn.
    
    // Required Methods
    
    //func scoreDidChange( from oldScore : Int, to newScore : Int )
    func gameDidStart()
    func gameDidStop()
    func gameDidEnd( withFinalScore score : Int )
}
