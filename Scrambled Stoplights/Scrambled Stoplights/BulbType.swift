/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

enum BulbType : String, CustomStringConvertible {
    case stop
    case slow
    case go
    case empty
    case clear
    case ghost
    
    var description : String  { return self.rawValue }
}
