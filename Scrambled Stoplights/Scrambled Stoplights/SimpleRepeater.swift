/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

class SimpleRepeater {
    // Timer Properties
    private        var _timer   : Timer!
    private( set ) var interval : TimeInterval // Interval in Seconds to Repeat
    
    // Initialization -
    init( every interval : TimeInterval ) {
        self.interval = interval
    }
    
    // Start Repeater Every Interval Seconds
    func start( doing action : ( () -> Void )? = nil ) {
        // Action to Repeat Every Interval
        func repeater( timer : Timer ) { if let action = action { action() } }
        
        // Internally Use Repeating Timer
        _timer = Timer( timeInterval : TimeInterval( interval ), repeats : true, block : repeater )
        
        // Run Timer
        RunLoop.main.add( _timer, forMode : .default )
    }
    
    // Stop the Timer
    func stop() { _timer.invalidate() }
}
