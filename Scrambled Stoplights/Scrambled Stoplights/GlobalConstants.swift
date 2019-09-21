/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit


// String type enum constants for segue identifier strings
enum Segue : String, CustomStringConvertible {
    // Cases
    
    case gameToSettings
    case gameToLeaderboard
    case gameToGameOver
    case settingsToDisplayName
    case settingsToAvatar
    case settingsToTrack
    case settingsToTheme
    
    // Properties
    
    var description : String { return self.rawValue }
}

// String type enum constants for reuseable cell identifier strings
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

// Numeric constants

// Uniform radius for rounded corners
let cornerRadius     : CGFloat      = 10

// Slowest timing interval for game loop
let slowInterval     : TimeInterval =  1.0

// Fastest timing interval for game loop and
// interval for held down control repeat
let fastInterval     : TimeInterval =  0.025
