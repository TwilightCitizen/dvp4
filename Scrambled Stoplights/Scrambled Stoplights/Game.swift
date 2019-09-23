/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit

class Game : WellDelegate, ForecastDelegate {
    // Properties
    
    // Delegate responsible for functionality dependent on the game
    internal       var delegate : GameDelegate
    
    // Well managed by the game
    private        var well     : Well! = nil
    
    // Forecast of stoplights required by the well, 7 stoplights out
    internal  lazy var forecast = { return StopLightForecast( delegate : self, length : 7 ) {
        return StopLight( top  : -3, left : ( self.well.contents.first!.count - 3 ) / 2 )
    } }()
    
    // Repeater for dropping stoplights in the well
    private( set ) var repeater : SimpleRepeater!
    // Game's running state
    private( set ) var running  = false
    // Statistics for the game
    private( set ) var score    = 0
    private( set ) var clears   = 0
    private( set ) var bestRun  = 0
    
    // Initializers
    
    init( delegate : GameDelegate ) {
        self.delegate = delegate
        self.well     = Well( delegate : self )
    }
    
    // Methods
    
    // Start a game
    func start() {
        // Either start from a cold start or a paused game
        if well.stopLight == nil {
            // Starting cold means the well needs a stoplight
            well.addStopLight()
            
            // Repeater to drop it now that its added
            repeater              = SimpleRepeater( every : slowInterval ) {
                self.well.dropDown()
                self.well.drawTo( well : self.delegate.well )
            }
            
            // Setup fresh game statistics
            score                 = 0
            clears                = 0
            bestRun               = 0
            delegate.score.text   = 0.withCommas
            delegate.clears.text  = 0.withCommas
            delegate.bestRun.text = 0.withCommas
            
            // Start dropping the stoplight
            repeater.start()
        } else {
            // Start dropping the stoplight at last obtained speed
            increaseSpeed()
        }
        
        // Show and hide various panels and elements accordingly
        delegate.gameDidStart( self )
        delegate.forecast.forEach { $0.isHidden  = false }
        delegate.controls.forEach { $0.isEnabled = true }
        
        running                  = true
        delegate.paused.isHidden = true
        delegate.nogame.isHidden = true
        delegate.well.isHidden   = false
        
        
        Music.current.play()
        Sound.tick.play()
    }
    
    // Stop a running game
    func stop()  {
        // Stop the repeater from dropping the stoplight
        repeater.stop()
        
        // Show and hide various panels and elements accordingly
        delegate.gameDidStop( self )
        delegate.controls.forEach { $0.isEnabled = false }
        delegate.forecast.forEach { $0.isHidden  = true }
        
        delegate.well.isHidden   = true
        delegate.paused.isHidden = false
        delegate.nogame.isHidden = true
        running                  = false
        
        Music.stop()
        Sound.tick.play()
    }
    
    // Quit a paused game or a running game that overflowed the well
    func reset() {
        // Setup for game over conditions
        delegate.gameDidStop( self )
        delegate.game( self, didEndWithScore : score, clears : clears, andBestRun : bestRun )
        delegate.forecast.forEach { $0.isHidden  = true }
        
        // Setup sample game statistics
        score                    = 123_456
        clears                   = 123
        bestRun                  = 123
        delegate.score.text      = score.withCommas
        delegate.clears.text     = clears.withCommas
        delegate.bestRun.text    = bestRun.withCommas
        
        // Show and hide various panels and elements accordingly
        running                  = false
        self.well                = Well( delegate : self )
        delegate.well.isHidden   = true
        delegate.paused.isHidden = true
        delegate.nogame.isHidden = false
        
        Music.stop()
        Sound.rasp.play()
    }
    
    // Bulbs in the well cleared out
    func well(_ well: Well, didClearBulbs bulbs: Int) {
        // Add 100 points to the score for each bulb cleared
        score                += 100 * bulbs
        // Add the clears
        clears               += bulbs
        // Replace the best run if bulbs cleare this go are greater
        bestRun               = bulbs > bestRun ? bulbs : bestRun
        
        // Update the statistics on the game screen
        delegate.score.text   = score.withCommas
        delegate.clears.text  = clears.withCommas
        delegate.bestRun.text = bestRun.withCommas
        
        // Increase the drop speed (possibly)
        increaseSpeed()
    }
    
    // Increase the rate at which stoplights drop inside the well
    func increaseSpeed() {
        // Basically, every 10 clears, increase the speed, starting from
        // the slow interval, by as much as the fast interval, capping out
        // at the fast interval as the top speed
        let tenClears = clears / 10
        let interval  = slowInterval - ( Double( tenClears ) * fastInterval )
        let capped    = interval < fastInterval ? fastInterval : interval
        
        // Replace the current repeater with the possibly faster one
        repeater      = SimpleRepeater( every : capped ) {
            self.well.dropDown()
            self.well.drawTo( well : self.delegate.well )
        }
        
        // And start it
        repeater.start()
    }
    
    // Game over when the well overflows
    func wellDidOverflow( _ well : Well ) { reset() }
    
    // As stoplights are manifest from the forecast and added to the well,
    // replace the on-screen forecast accordingly
    func forecastDidChange( forecast : StopLightForecast ) {
        func draw( light : StopLight, to view : UIView ) {
            light.contents.enumerated().forEach { row in
                row.element.enumerated().forEach { col in
                    let bulb = light.contents[ row.offset ][ col.offset ]
                    
                    ( view.subviews[ row.offset ] .subviews[ col.offset ] as! UIImageView ).image = bulb.image
                }
            }
        }
        
        for light in forecast.contents.enumerated() {
            draw( light: light.element, to: delegate.forecast[ light.offset ] )
        }
    }
    
    // Manipulations to pass to the well to apply to the currently dropping stoplight, if any
    // Manipulations cost 10 points each, except for drops which just hasten what the game will
    // do automatically anyway
    
    func cycleUp()       { well.cycleUp();       score -= 10; well.drawTo( well: delegate.well ) }
    func cycleDown()     { well.cycleDown();     score -= 10; well.drawTo( well: delegate.well ) }
    func rotateCounter() { well.rotateCounter(); score -= 10; well.drawTo( well: delegate.well ) }
    func rotateClock()   { well.rotateClock();   score -= 10; well.drawTo( well: delegate.well ) }
    func moveLeft()      { well.moveLeft();      score -= 10; well.drawTo( well: delegate.well ) }
    func moveRight()     { well.moveRight();     score -= 10; well.drawTo( well: delegate.well ) }
    
    func dropDown()      { well.dropDown();                   well.drawTo( well: delegate.well ) }
}
