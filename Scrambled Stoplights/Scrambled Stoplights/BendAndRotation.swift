/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation

// Bends and/or rotations change the orientation of 3 primary bulbs within
// a 3x3 grid, filling out the rest with empty bulbs
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
    
    // Next bend and/or rotation after the current one, or the
    // first one in the case of the last one
    var next        : BendAndRotation {
        let cases = BendAndRotation.allCases
        let index = cases.firstIndex( of : self )! + 1
        
        guard index < cases.count else { return cases.first! }
        
        return cases[ index ]
    }
    
    // Previous bend and/or rotation before the current one, or
    // the last one in the cast of the first one
    var previous    : BendAndRotation {
        let cases = BendAndRotation.allCases
        let index = cases.firstIndex( of : self )! - 1
        
        guard index > -1 else { return cases.last! }
        
        return cases[ index ]
    }
    
    // Methods
    
    // Orient the 3 primary bulbs in the 3x3 grid according to
    // the currently selected bend and/or rotation
    func ofBulbs( _ bulbs : [ Bulb ] ) -> [ [ Bulb ] ] {
        // Constant for empty bulb
        let empty = Bulb( ofType : .empty )
        
        // Constants for primary bulbs
        let first = bulbs[ 0 ]
        let secnd = bulbs[ 1 ]
        let third = bulbs[ 2 ]
        
        // 3x3 grids corresponding to current bend and/or rotation
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
