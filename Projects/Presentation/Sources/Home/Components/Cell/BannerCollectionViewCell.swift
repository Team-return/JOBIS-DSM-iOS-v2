import UIKit
import Domain
import SnapKit
import Then
import DesignSystem

final class BannerCollectionViewCell: BaseCollectionViewCell<UIImage> {
    static let identifier = "BannerCollectionViewCell"
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }

    override func addView() {
        [
            imageView
        ].forEach(self.addSubview(_:))
    }

    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func configureView() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .GrayScale.gray30
    }

    override func adapt(model: UIImage) {
        self.imageView.image = model
    }
}
