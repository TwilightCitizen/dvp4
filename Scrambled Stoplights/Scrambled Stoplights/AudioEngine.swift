/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import AVFoundation

// Singleton Game Audio Engine
class AudioEngine {
    // Audio Players for Sounds and Music
    private static var sound = AVAudioPlayer()
    private static var music = AVAudioPlayer()
    
    private init() {}
    
    // Tweaked the audio engine to take a game audio conforming game sound or
    // game music enum.
    
    // Play Name Audio on Audio Audio Player
    static func playAudio( _ audio : Audio ) {
        guard let url = Bundle.main.url(
            forResource   : audio.name,
            withExtension : "mp3"//,
        ) else { return }
        
        // Music repeats and plays at lower volume to sounds.
        let loops          = audio is Music ? -1   : 0
        let volume : Float = audio is Music ? 0.25 : 1.0
        
        func playAudioOn( _ player : inout AVAudioPlayer ) {
            // Prepare to Access Audio Device
            do {
                try AVAudioSession.sharedInstance().setMode( .default )
                try AVAudioSession.sharedInstance().setActive( true )
                
                player = try AVAudioPlayer( contentsOf : url, fileTypeHint : AVFileType.mp3.rawValue )
                
                player.numberOfLoops = loops
                player.volume        = volume
                
                player.play()
            } catch { /* Boo... No sound! :( */ }
        }
        
        // Separate Players so Sounds Do Not Stop Music
        if audio is Music { playAudioOn( &music ) } else { playAudioOn( &sound ) }
    }
    
    // Not sure how to hide this from everywhere except GameMusic.
    static func stopMusic()   { music.stop() }
    static func toggleMusic() { music.volume = music.volume == 0 ? 0.25 : 0 }
}
