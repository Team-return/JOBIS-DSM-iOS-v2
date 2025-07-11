import UIKit

final class ClassEmploymentCollectionViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {
        let cellSpacing: CGFloat = 8
        let sectionInset: CGFloat = 24
        let totalSpacing = (cellSpacing * 3) + (sectionInset * 2)
        let cellWidth = (UIScreen.main.bounds.width - totalSpacing) / 4

        self.minimumLineSpacing = 50
        self.minimumInteritemSpacing = cellSpacing
        self.itemSize = CGSize(width: cellWidth, height: cellWidth)
        self.sectionInset = UIEdgeInsets(top: 10, left: sectionInset, bottom: 0, right: sectionInset)
    }
}
