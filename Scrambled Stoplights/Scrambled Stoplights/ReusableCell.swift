/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

// String type enum constants for reuseable cell identifier strings
enum ReusableCell : String, CustomStringConvertible {
    // Cases
    
    case avatar
    case leader
    case track
    case selectableSetting
    case slideableSetting
    
    case SettingsHeader
    case settingsHeader
    
    // Properties
    
    var description : String { return self.rawValue }
}
