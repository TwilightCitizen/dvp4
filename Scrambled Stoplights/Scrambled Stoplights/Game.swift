/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit

class Game : GameWellDelegate {
    // Properties
    
                   var delegate : GameDelegate
    private   lazy var well     = { return GameWell( delegate : self ) }()
    
    private( set ) var repeater = SimpleRepeater( every : slowInterval )
    private( set ) var running  = false
    private( set ) var score    = 0
    
    // Initializers
    
    init( delegate : GameDelegate ) { self.delegate = delegate }
    
    // Methods
    func start() {
        if well.trafficLight == nil {
            well.addTrafficLight()
            delegate.scoreDidChange( from : 123_456, to : 0 )
        }
        
        repeater.start() {
            self.well.dropDown()
            self.well.drawTo( well : self.delegate.well )
        }
        
        running = true
        
        delegate.gameDidStart()
    }
    
    func stop()  {
        repeater.stop()
        delegate.gameDidStop()
        
        running = false
    }
    
    func clearDidOccur( forBulbs : Int ) {
        let newScore = score + ( 100 * forBulbs )
        
        delegate.scoreDidChange( from : score, to : newScore )
        
        score = newScore
    }
    
    func wellDidOverflow() {
        repeater.stop()
        delegate.gameDidStop()
        delegate.gameDidEnd( withFinalScore : score )
        
        well = GameWell( delegate : self )
    }
    
    func reset() {} // TODO: Figure Out Game Resetting
    
    func cycleUp()       { well.cycleUp();       well.drawTo( well: delegate.well ) }
    func cycleDown()     { well.cycleDown();     well.drawTo( well: delegate.well ) }
    func rotateCounter() { well.rotateCounter(); well.drawTo( well: delegate.well ) }
    func rotateClock()   { well.rotateClock();   well.drawTo( well: delegate.well ) }
    func moveLeft()      { well.moveLeft();      well.drawTo( well: delegate.well ) }
    func moveRight()     { well.moveRight();     well.drawTo( well: delegate.well ) }
    func dropDown()      { well.dropDown();      well.drawTo( well: delegate.well ) }
}
