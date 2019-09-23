/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */


import Foundation

// All music is royalty free, courtesy of Eric Matyas at Soundimage.org,
// free to use with credit attribution
enum Music : String, CaseIterable, Audio, Specifiable, Codable {
    // Cases
    
    case puzzleDreams, mindBender, bubbleGumPuzzler
    
    // Properties
    
    static let key       =  CodeableKey.music
    
    // Specified track is provided externally
    static var specified : Music? = nil
    
    // Fallback track is first one, or puzzle dreams
    static var fallback  : Music  { return self.allCases.first! }
    
    var name             : String { return rawValue     }
    
    // Volume defaults to global music volume
    var volume           : Float  { return Music.volume }
    static var volume    : Float  = 0.5
    
    // Methods
    
    // Music repeats on loop, so should be stoppable after playing.
    func play()        { AudioEngine.playAudio( self ) }
    func stop()        { AudioEngine.stopMusic()       }
    static func stop() { AudioEngine.stopMusic()       }
}
