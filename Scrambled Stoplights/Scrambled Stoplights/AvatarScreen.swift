/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import UIKit

class AvatarScreen : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // Outlets
    
    // Properties
    
    // Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView( _ collectionView : UICollectionView, numberOfItemsInSection section : Int ) -> Int {
        return 1
    }
    
    func collectionView( _ collectionView : UICollectionView, cellForItemAt indexPath : IndexPath ) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
