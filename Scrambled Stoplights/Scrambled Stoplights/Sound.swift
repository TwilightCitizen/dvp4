/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */


import Foundation

// All sounds are royalty free, courtesy of ZAPSPLAT at zapsplat.com
// and Sound Jay and soundjay.com free to use with credit attribution.

enum Sound : String, CaseIterable, Audio {
    // Cases
    
    case chirp, rasp, tap, tick, swish
    
    // Properties
    
    var name          : String { return rawValue     }
    var volume        : Float  { return Sound.volume }
    
    static var volume : Float  = 1.0
    
    // Methods
    
    // Sounds are short and just play through.
    func play() { AudioEngine.playAudio( self ) }
}
