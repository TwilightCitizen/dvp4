/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

protocol Codeable : CustomStringConvertible, RawRepresentable where RawValue == String {
    // Required Properties
    
    static var key : CodeableKey { get }
    
    // Optional Properties
    
    var encoded    : Data        { get }
    
    // Optional Methods
    
    static func decodeFrom( _ data : Data? ) -> Self?
}

extension Codeable {
    var encoded    : Data  { return ( Self.key.description + description ).data( using : .utf8 )! }
    
    static func decodeFrom( _ data : Data? ) -> Self? {
        guard let data     = data                                               else { return nil }
        guard let decoded  = String( bytes : data, encoding : .utf8 )           else { return nil }
        
        guard String( decoded.prefix( key.length ) ) == key.description         else { return nil }
        
        guard let codeable = Self.init( rawValue : String( String(
            bytes : data, encoding : .utf8 )?.dropFirst( key.length ) ?? "" ) ) else { return nil }
        
        return codeable
    }
}

enum CodeableKey : String, CustomStringConvertible {
    // Cases
    
    case theme, displayName, avatar, placing, music
    
    // Properties
    
    var description : String  { return self.rawValue     }
    
    var length      : Int     { return description.count }
}
