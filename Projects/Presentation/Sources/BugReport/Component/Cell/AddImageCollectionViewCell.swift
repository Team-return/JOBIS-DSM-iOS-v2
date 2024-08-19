import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class AddImageCollectionViewCell: BaseCollectionViewCell<Any> {
    static let identifier = "AddImageCollectionViewCell"
    private let bugImageView = UIImageView().then {
        $0.image = UIImage(systemName: "photo")
        $0.tintColor = .GrayScale.gray60
    }
    private let addImageLabel = UILabel().then {
        $0.setJobisText(
            "이미지 추가",
            font: .body,
            color: .GrayScale.gray60
        )
    }

    override func addView() {
        [
            bugImageView,
            addImageLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }

    override func setLayout() {
        bugImageView.snp.makeConstraints {
            $0.height.width.equalTo(36)
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }

        addImageLabel.snp.makeConstraints {
            $0.top.equalTo(bugImageView.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
    }

    override func configureView() { }
}
