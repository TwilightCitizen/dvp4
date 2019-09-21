/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

class StopLightForecast : Forecast {
    // Forecast of stoplights
    typealias T = StopLight
    // Game will manage stoplight forecasts
    typealias U = Game
    
    // IDEA : A Delegate-Delegate might alleviate tight coupling to a particular concrete delegate..
    
    internal var delegate  : U
    internal var contents  : [ T ]
    internal var generator : () -> T
    
    required init( delegate : U, length : Int, generator : @escaping () -> T ) {
        self.delegate  = delegate
        self.generator = generator
        
        // Generate a forecast of length stoplights
        self.contents  = ( 0..<length ).map { _ in return generator() }
    }
    
    // As stoplight are manifest from the forecast, remove them and add another like a queue
    // Also alert the delegate
    func manifest() -> T {
        contents.append( generator() )
        
        let manifest = contents.removeFirst()
        
        delegate.forecastDidChange( forecast : self )
        
        return manifest
    }
}
