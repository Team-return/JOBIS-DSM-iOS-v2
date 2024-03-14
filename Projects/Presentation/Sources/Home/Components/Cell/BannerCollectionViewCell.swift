import UIKit
import Domain
import SnapKit
import Then
import DesignSystem

final class BannerCollectionViewCell: BaseCollectionViewCell<FetchBannerEntity> {
    static let identifier = "BannerCollectionViewCell"
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }

    override func addView() {
        [
            imageView
        ].forEach(contentView.addSubview(_:))
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

    override func adapt(model: FetchBannerEntity) {
        self.imageView.setJobisImage(urlString: model.bannerURL)
    }
}
