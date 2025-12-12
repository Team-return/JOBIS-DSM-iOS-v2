import Foundation
import UIKit

extension LeftAlignedCollectionViewFlowLayout {
    func applyDefaultLayout() {
        self.minimumLineSpacing = 8
        self.minimumInteritemSpacing = 8
        self.scrollDirection = .vertical
        self.itemSize = UICollectionViewFlowLayout.automaticSize
        self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.sectionInset = .init(top: 8, left: 0, bottom: 8, right: 0)
    }
}
