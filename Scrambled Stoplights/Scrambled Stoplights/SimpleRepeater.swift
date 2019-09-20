/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

class SimpleRepeater {
    // Properties
    
    private( set ) var interval : TimeInterval
    private        var timer    : Timer
    
    // Initializers
    init( every interval : TimeInterval, do action : ( () -> Void )? = nil ) {
        self.interval = interval
        
        self.timer    = Timer( timeInterval : interval, repeats : true ) {
            _ in if let action = action { action() }
        }
    }
    
    deinit { stop() }
    
    // Methods
    func start() { RunLoop.main.add( timer, forMode : .default ) }
    func stop()  { timer.invalidate()                            }
}
