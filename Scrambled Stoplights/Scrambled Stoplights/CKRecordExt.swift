/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import Foundation
import CloudKit

extension CKRecord {
    // Provide subscripting by CloudKitRecord string type enum constants
    subscript( key : CloudKitRecord ) -> Any? {
        get { return self[ key.description ]                       }
        set { self[ key.description ] = newValue as? CKRecordValue }
    }
}
