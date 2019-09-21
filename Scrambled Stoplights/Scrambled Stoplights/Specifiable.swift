/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

protocol Specifiable {
    // Required Properties
    
    static var specified : Self? { get set }
    static var fallback  : Self  { get     }
    
    // Optional Properties
    
    static var current   : Self  { get     }
}

extension Specifiable {
    static var current   : Self  { return specified ?? fallback }
}
