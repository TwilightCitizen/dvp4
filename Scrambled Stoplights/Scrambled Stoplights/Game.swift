/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit

class Game {
    // Properties
    
    private( set ) var delegate : GameDelegate
    private( set ) var well     : GameWell
    
    private( set ) var repeater = SimpleRepeater( every : slowInterval )
    private( set ) var running  = false
    private( set ) var score    = 0
    
    // Initializers
    
    init( delegate : GameDelegate ) {
        self.delegate = delegate
        self.well     = GameWell( matching : delegate.well )
    }
    
    // Methods
    func start() {
        if well.trafficLight == nil { well.addTrafficLight() }
        
        repeater.start() {
            self.well.dropDown()
            self.well.drawTo( well : self.delegate.well )
        }
        
        running = true
    }
    
    func stop()  { repeater.stop(); running = false }
    
    func reset() {} // TODO: Figure Out Game Resetting
    
    func cycleUp()       { well.cycleUp();       well.drawTo( well: delegate.well ) }
    func cycleDown()     { well.cycleDown();     well.drawTo( well: delegate.well ) }
    func rotateCounter() { well.rotateCounter(); well.drawTo( well: delegate.well ) }
    func rotateClock()   { well.rotateClock();   well.drawTo( well: delegate.well ) }
    func moveLeft()      { well.moveLeft();      well.drawTo( well: delegate.well ) }
    func moveRight()     { well.moveRight();     well.drawTo( well: delegate.well ) }
    func dropDown()      { well.dropDown();      well.drawTo( well: delegate.well ) }
}
