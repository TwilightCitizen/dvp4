/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

extension Int {
    // Convert to a string formatted with commas between groups of 3 digits
    var withCommas : String {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        
        return formatter.string( from: NSNumber( value : self ) )!
    }
}
