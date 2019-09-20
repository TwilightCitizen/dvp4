/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import UIKit

protocol GameDelegate {
    // Required Properties
    
    var well     : UIView!       { get set }
    var paused   : UIView!       { get set }
    var nogame   : UIView!       { get set }
    var forecast : [ UIView ]!   { get set }
    var controls : [ UIButton ]! { get set }
    
    var score    : UILabel!      { get set }
    var clears   : UILabel!      { get set }
    var bestRun  : UILabel!      { get set }
    
    // Required Methods
    
    // Optional Methods
    
    func gameDidStart( _ game : Game )
    func gameDidStop(  _ game : Game )
    
    func game( _ game : Game, scoreDidChangeFrom   oldScore  : Int, to newScore  : Int                        )
    func game( _ game : Game, clearsDidChangeFrom  oldClears : Int, to newClears : Int                        )
    func game( _ game : Game, bestRunDidChangeFrom oldBest   : Int, to newBest   : Int                        )
    func game( _ game : Game, didEndWithScore      score     : Int, clears       : Int, andBestRun best : Int )
}

extension GameDelegate {
    func gameDidStart( _ game : Game ) {}
    func gameDidStop(  _ game : Game ) {}
    
    func game( _ game : Game, scoreDidChangeFrom   oldScore  : Int, to newScore  : Int                        ) {}
    func game( _ game : Game, clearsDidChangeFrom  oldClears : Int, to newClears : Int                        ) {}
    func game( _ game : Game, bestRunDidChangeFrom oldBest   : Int, to newBest   : Int                        ) {}
    func game( _ game : Game, didEndWithScore      score     : Int, clears       : Int, andBestRun best : Int ) {}
}
