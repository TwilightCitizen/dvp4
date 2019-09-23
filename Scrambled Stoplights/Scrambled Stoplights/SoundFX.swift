/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */


import Foundation

enum SoundFX : String, CaseIterable,  Audio {
    // Cases
    
    case one, two, three
    
    // Properties
    
    var name : String { return rawValue }
    
    // Methods
    
    // Sounds are short and just play through.
    func play() { AudioEngine.playAudio( self ) }
}
