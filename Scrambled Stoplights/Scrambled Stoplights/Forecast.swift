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
    
    // Element of a forecast
    associatedtype T
    
    // Delegate for a forecast that manages the above element type
    associatedtype U where U : ForecastDelegate
    
    // Required Properties
    
    // Delegate responsible for certain forecast behaviors
    var delegate  : U       { get set }
    
    // Elements of a forcast
    var contents  : [ T ]   { get set }
    
    // Method to call that generates and returns a forcast element somehow
    var generator : () -> T { get set }
    
    // Required Initializers
    
    init( delegate : U, length : Int, generator : @escaping () -> T )
    
    // Required Methods
    
    func manifest() -> T
}
