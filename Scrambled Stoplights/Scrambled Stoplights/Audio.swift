/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */


import Foundation

// Protocol followed by SoundFX and Music.

protocol Audio {
    // Properties
    
    var name          : String { get     }
    var volume        : Float  { get     }
    static var volume : Float  { get set }
    
    // Methods
    
    func play()
}
