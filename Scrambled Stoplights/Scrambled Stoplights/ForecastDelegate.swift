/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

protocol ForecastDelegate {
    // Associated Types
    
    associatedtype T where T : Forecast
    
    // Required Properties
    
    // Required Methods
    
    func forecastDidChange( forecast : T )
}
