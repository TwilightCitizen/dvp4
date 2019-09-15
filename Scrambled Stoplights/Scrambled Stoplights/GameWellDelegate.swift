/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit

protocol GameWellDelegate {
    // Required Properties
    var delegate : GameDelegate  { get set }
    
    // Required Methods
    
    func clearDidOccur( forBulbs : Int )
    func wellDidOverflow()
}
