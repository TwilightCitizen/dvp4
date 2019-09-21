/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit

// Bulbs are the primary component that comprise StopLights and/or the game's Well
class Bulb {
    // Properties
    
    let bulbType   : BulbType
    let bulbWeight : BulbWeight?
    
    // For mark/sweep clearing from the Well
    var clearable  = false
    
    // Bulb image comprised of Theme, Bulb Type, and Bulb Weight concatentated
    var image      : UIImage { return UIImage( named :
        Theme.current.description + bulbType.description + ( bulbWeight?.description ?? "" )
    )! }
    
    // Initializers
    
    init( ofType bulbType : BulbType, withWeight bulbWeight : BulbWeight? = nil ) {
        self.bulbType = bulbType; self.bulbWeight = bulbWeight
    }
    
    // Methods
}
