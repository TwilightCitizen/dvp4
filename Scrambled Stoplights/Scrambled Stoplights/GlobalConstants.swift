/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit

enum CoreData     : String, CustomStringConvertible {
    // Cases
    
    case scrambledStoplights
    
    // Properties
    
    var description : String { return self.rawValue }
}

enum Segue        : String, CustomStringConvertible {
    // Cases
    
    case settingsToDisplayName
    case settingsToAvatar
    case settingsToTrack
    case settingsToTheme
    
    // Properties
    
    var description : String { return self.rawValue }
}

enum ReusableCell : String, CustomStringConvertible {
    // Cases
    
    case avatar
    case leader
    case track
    case selectableSetting
    case slideableSetting
    
    // Properties
    
    var description : String { return self.rawValue }
}

let cornerRadius     : CGFloat      = 10
let slowRepeat       : TimeInterval =  1.0
let fastRepeat       : TimeInterval =  0.0625
let fortyFiveDegrees : CGFloat      =  0.785
