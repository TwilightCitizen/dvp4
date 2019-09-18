/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

class Forecast< T > {
    // Properties
    
    private( set ) var delegate  : ForecastDelegate
    private( set ) var contents  : [ T ]
    private        var generator : () -> T
    
    // Initializers
    
    init( delegate : ForecastDelegate, length : Int, generator : @escaping () -> T ) {
        self.delegate  = delegate
        self.generator = generator
        self.contents  = ( 0..<length ).map { _ in return generator() }
    }
    
    // Methods
    
    func manifest() -> T {
        contents.append( generator() )
        
        let manifest = contents.removeFirst()
        
        delegate.forecastDidChange()
        
        return manifest
    }
}