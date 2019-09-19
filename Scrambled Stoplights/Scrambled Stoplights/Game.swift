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
    
                   var delegate : GameDelegate
    private   lazy var well     = { return Well( delegate : self ) }()
    
              lazy var forecast = { return Forecast< StopLight >( delegate : self, length : 7 ) {
        return StopLight( top  : -3, left : ( self.well.contents.first!.count - 3 ) / 2 )
    } }()
    
    private( set ) var repeater = SimpleRepeater( every : slowInterval )
    private( set ) var running  = false
    private( set ) var score    = 0
    private( set ) var clears   = 0
    private( set ) var bestRun  = 0
    
    // Initializers
    
    init( delegate : GameDelegate ) { self.delegate = delegate }
    
    // Methods
    func start() {
        if well.stopLight == nil {
            well.addStopLight()
            
            delegate.score.text   = 0.withCommas
            delegate.clears.text  = 0.withCommas
            delegate.bestRun.text = 0.withCommas
        }
        
        repeater.start() {
            self.well.dropDown()
            self.well.drawTo( well : self.delegate.well )
        }
        
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
    
    func clearDidOccur( forBulbs : Int ) {
        score                += 100 * forBulbs
        clears               += forBulbs
        delegate.score.text   = score.withCommas
        delegate.clears.text  = clears.withCommas
        bestRun               = forBulbs > bestRun ? forBulbs : bestRun
        delegate.bestRun.text = bestRun.withCommas
        
        increaseSpeed()
    }
    
    func increaseSpeed() {
        repeater.stop()
        
        let tenClears = clears / 10
        let interval  = slowInterval - ( Double( tenClears ) * fastInterval )
        let capped    = interval < fastInterval ? fastInterval : interval
        
        repeater = SimpleRepeater( every : capped )
        
        repeater.start() {
            self.well.dropDown()
            self.well.drawTo( well : self.delegate.well )
        }
        
        print( interval )
    }
    
    func wellDidOverflow() {
        repeater.stop()
        delegate.gameDidStop( self )
        delegate.game( self, didEndWithScore : score )
        
        well = Well( delegate : self )
    }
    
    func forecastDidChange() {
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
    
    func reset() {} // TODO: Figure Out Game Resetting
    
    func cycleUp()       { well.cycleUp();       score -= 10; well.drawTo( well: delegate.well ) }
    func cycleDown()     { well.cycleDown();     score -= 10; well.drawTo( well: delegate.well ) }
    func rotateCounter() { well.rotateCounter(); score -= 10; well.drawTo( well: delegate.well ) }
    func rotateClock()   { well.rotateClock();   score -= 10; well.drawTo( well: delegate.well ) }
    func moveLeft()      { well.moveLeft();      score -= 10; well.drawTo( well: delegate.well ) }
    func moveRight()     { well.moveRight();     score -= 10; well.drawTo( well: delegate.well ) }
    
    func dropDown()      { well.dropDown();                   well.drawTo( well: delegate.well ) }
}
