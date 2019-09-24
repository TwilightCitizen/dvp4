/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

// String type enum constants for segue identifier strings
enum Segue : String, CustomStringConvertible {
    // Cases
    
    case gameToSettings
    case gameToLeaderboard
    
    // Properties
    
    var description : String { return self.rawValue }
}
