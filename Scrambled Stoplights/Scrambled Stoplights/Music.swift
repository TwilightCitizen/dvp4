/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */


import Foundation

enum Music : String, CaseIterable, Audio {
    // Cases
    
    case one, two, three
    
    // Properties
    
    var name : String { return rawValue }
    
    // Methods
    
    // Music repeats on loop, so should be stoppable after playing.
    func play() {AudioEngine.playAudio( self ) }
    func stop() { AudioEngine.stopMusic() }
}
