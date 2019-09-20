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
    
    internal       var delegate : GameDelegate
    
    private        var well     : Well! = nil
    
    internal  lazy var forecast = { return StopLightForecast( delegate : self, length : 7 ) {
        return StopLight( top  : -3, left : ( self.well.contents.first!.count - 3 ) / 2 )
    } }()
    
    private( set ) var repeater : SimpleRepeater!
    private( set ) var running  = false
    private( set ) var score    = 0
    private( set ) var clears   = 0
    private( set ) var bestRun  = 0
    
    // Initializers
    
    init( delegate : GameDelegate ) {
        self.delegate = delegate
        self.well     = Well( delegate : self )
    }
    
    // Methods
    func start() {
        if well.stopLight == nil {
            well.addStopLight()
            
            repeater              = SimpleRepeater( every : slowInterval ) {
                self.well.dropDown()
                self.well.drawTo( well : self.delegate.well )
            }
            
            delegate.score.text   = 0.withCommas
            delegate.clears.text  = 0.withCommas
            delegate.bestRun.text = 0.withCommas
        }
        
        repeater.start()
        
        running                  = true
        delegate.paused.isHidden = true
        delegate.well.isHidden   = false
        
        delegate.forecast.forEach { $0.isHidden  = false }
        delegate.controls.forEach { $0.isEnabled = true }
        delegate.gameDidStart( self )
    }
    
    func stop()  {
        repeater.stop()
        delegate.gameDidStop( self )
        delegate.controls.forEach { $0.isEnabled = false }
        delegate.forecast.forEach { $0.isHidden  = true }
        
        delegate.well.isHidden   = true
        delegate.paused.isHidden = false
        running                  = false
    }
    
    func reset() {
        delegate.gameDidStop( self )
        delegate.game( self, didEndWithScore : score )
        
        score                    = 0
        clears                   = 0
        bestRun                  = 0
        delegate.score.text      = score.withCommas
        delegate.clears.text     = clears.withCommas
        delegate.bestRun.text    = bestRun.withCommas
        running                  = false
        self.well                = Well( delegate : self )

        delegate.well.isHidden   = true
        delegate.paused.isHidden = true
    }
    
    func well(_ well: Well, didClearBulbs bulbs: Int) {
        score                += 100 * bulbs
        clears               += bulbs
        delegate.score.text   = score.withCommas
        delegate.clears.text  = clears.withCommas
        bestRun               = bulbs > bestRun ? bulbs : bestRun
        delegate.bestRun.text = bestRun.withCommas
        
        increaseSpeed()
    }
    
    func increaseSpeed() {
        let tenClears = clears / 10
        let interval  = slowInterval - ( Double( tenClears ) * fastInterval )
        let capped    = interval < fastInterval ? fastInterval : interval
        
        repeater      = SimpleRepeater( every : capped ) {
            self.well.dropDown()
            self.well.drawTo( well : self.delegate.well )
        }
        
        repeater.start()
    }
    
    func wellDidOverflow( _ well : Well ) {
        reset()
    }
    
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
    
    func cycleUp()       { well.cycleUp();       score -= 10; well.drawTo( well: delegate.well ) }
    func cycleDown()     { well.cycleDown();     score -= 10; well.drawTo( well: delegate.well ) }
    func rotateCounter() { well.rotateCounter(); score -= 10; well.drawTo( well: delegate.well ) }
    func rotateClock()   { well.rotateClock();   score -= 10; well.drawTo( well: delegate.well ) }
    func moveLeft()      { well.moveLeft();      score -= 10; well.drawTo( well: delegate.well ) }
    func moveRight()     { well.moveRight();     score -= 10; well.drawTo( well: delegate.well ) }
    
    func dropDown()      { well.dropDown();                   well.drawTo( well: delegate.well ) }
}
