/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit

protocol WellDelegate {
    // Required Properties
    
    var delegate : GameDelegate      { get set }
    var forecast : StopLightForecast { get set }
    
    // Required Methods
    
    // Optional Methods
    
    func well( _ well : Well, didClearBulbs bulbs : Int )
    
    func wellDidOverflow( _ well : Well )
}

extension WellDelegate {
    func well( _ well : Well, didClearBulbs bulbs : Int ) {}
    
    func wellDidOverflow( _ well : Well ) {}
}
