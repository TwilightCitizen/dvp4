/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

class StopLightForecast : Forecast {
    typealias T = StopLight
    typealias U = Game
    
    var delegate  : U
    var contents  : [ T ]
    var generator : () -> T
    
    required init( delegate : U, length : Int, generator : @escaping () -> T ) {
        self.delegate  = delegate
        self.generator = generator
        self.contents  = ( 0..<length ).map { _ in return generator() }
    }
    
    func manifest() -> T {
        contents.append( generator() )
        
        let manifest = contents.removeFirst()
        
        delegate.forecastDidChange( forecast : self )
        
        return manifest
    }
}
