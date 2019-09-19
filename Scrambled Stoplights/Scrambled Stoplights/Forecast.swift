/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

protocol Forecast {
    // Associated Types
    
    associatedtype T
    associatedtype U where U : ForecastDelegate
    
    // Required Properties
    
    var delegate  : U       { get set }
    var contents  : [ T ]   { get set }
    var generator : () -> T { get set }
    
    // Required Initializers
    
    init( delegate : U, length : Int, generator : @escaping () -> T )
    
    // Required Methods
    
    func manifest() -> T
}
