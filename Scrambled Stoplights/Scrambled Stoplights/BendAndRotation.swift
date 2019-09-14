/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

enum BendAndRotation : String, CustomStringConvertible, CaseIterable {
    // Cases
    
    case topToBottom
    case leftToBottom
    case leftToRight
    case bottomToRight
    case bottomToTop
    case rightToTop
    case rightToLeft
    case rightToBottom
    
    // Properties
    
    var description : String          { return self.rawValue }
    
    var next        : BendAndRotation {
        let cases = BendAndRotation.allCases
        let index = cases.firstIndex( of : self )! + 1
        
        guard index < cases.count else { return cases.first! }
        
        return cases[ index ]
    }
    
    var previous    : BendAndRotation {
        let cases = BendAndRotation.allCases
        let index = cases.firstIndex( of : self )! - 1
        
        guard index > -1 else { return cases.last! }
        
        return cases[ index ]
    }
    
    // Methods
    
    func ofBulbs( _ bulbs : [ Bulb ] ) -> [ [ Bulb ] ] {
        let empty = Bulb( ofType : .empty )
        let first = bulbs[ 0 ]
        let secnd = bulbs[ 1 ]
        let third = bulbs[ 2 ]
        
        switch self {
            case .topToBottom   :
                return [ [ empty, first, empty ]
                       , [ empty, secnd, empty ]
                       , [ empty, third, empty ] ]
            
            case .leftToBottom  :
                return [ [ empty, empty, empty ]
                       , [ first, secnd, empty ]
                       , [ empty, third, empty ] ]
            
            case .leftToRight   :
                return [ [ empty, empty, empty ]
                       , [ first, secnd, third ]
                       , [ empty, empty, empty ] ]
            
            case .bottomToRight :
                return [ [ empty, empty, empty ]
                       , [ empty, secnd, third ]
                       , [ empty, first, empty ] ]
            
            case .bottomToTop   :
                return [ [ empty, third, empty ]
                       , [ empty, secnd, empty ]
                       , [ empty, first, empty ] ]
            
            case .rightToTop    :
                return [ [ empty, third, empty ]
                       , [ empty, secnd, first ]
                       , [ empty, empty, empty ] ]
            
            case .rightToLeft   :
                return [ [ empty, empty, empty ]
                       , [ third, secnd, first ]
                       , [ empty, empty, empty ] ]
            
            case .rightToBottom :
                return [ [ empty, first, empty ]
                       , [ third, secnd, empty ]
                       , [ empty, empty, empty ] ]
        }
    }
}
