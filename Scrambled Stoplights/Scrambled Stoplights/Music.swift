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
    
    // Specified theme is provided externally
    static var specified : Music? {
        get {
            guard let rawValue = UserDefaults.standard.string( forKey : key.description ) else { return nil }
            
            return Music.init( rawValue : rawValue )
        }
        
        set { UserDefaults.standard.set( newValue!.rawValue, forKey : key.description ) }
    }
    
    // Fallback track is first one, or puzzle dreams
    static var fallback  : Music  { return self.allCases.first! }
    
    var name             : String { return rawValue     }
    
    // Volume defaults to global music volume
    var volume           : Float  { return Music.volume }
    
    static var volume    : Float  {
        get {
            guard UserDefaults.standard.object( forKey : key.description + CodeableKey.volume.description ) != nil else { return 0.5 }
            return UserDefaults.standard.float( forKey : key.description + CodeableKey.volume.description )
        }
        
        set { UserDefaults.standard.set( newValue, forKey : key.description + CodeableKey.volume.description ) }
    }
        
    // Methods
    
    // Music repeats on loop, so should be stoppable after playing.
    func play()        { AudioEngine.playAudio( self ) }
    func stop()        { AudioEngine.stopMusic()       }
    static func stop() { AudioEngine.stopMusic()       }
}
