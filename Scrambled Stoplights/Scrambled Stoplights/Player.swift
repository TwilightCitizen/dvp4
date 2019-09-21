/* David Clark
 * MDV3730-O
 * Multipeer Connectivity Project 5.2
 * 2019-08-11
 */

import Foundation

protocol Player {
    // Required Properties
    
    var delegate     : PlayerDelegate { get set }
    var displayName  : String!        { get     }
    var avatar       : Avatar!        { get     }
}
