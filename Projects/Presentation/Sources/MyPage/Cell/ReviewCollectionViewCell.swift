import UIKit
import DesignSystem
import Domain

final class ReviewCollectionViewCell: BaseCollectionViewCell<WritableReviewCompanyEntity> {
    static let identifier = "ReviewCollectionViewCell"
    private let reviewImageView = UIImageView().then {
        $0.image = .jobisIcon(.door)
    }
    private let titleLabel = UILabel().then {
        $0.setJobisText("", font: .description, color: .GrayScale.gray70)
    }
    private let reviewNavigateLabel = UILabel().then {
        $0.setJobisText("작성하러 가기 →", font: .subHeadLine, color: .Primary.blue20)
    }
    override func addView() {
        [
            reviewImageView,
            titleLabel,
            reviewNavigateLabel
        ].forEach(contentView.addSubview(_:))
    }

    override func setLayout() {
        reviewImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
            $0.leading.equalToSuperview().inset(16)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(reviewImageView.snp.trailing).offset(8)
            $0.height.equalTo(20)
            $0.trailing.equalToSuperview().inset(16)
        }
        reviewNavigateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.height.equalTo(24)
            $0.leading.equalTo(reviewImageView.snp.trailing).offset(8)
        }
    }

    override func configureView() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .Primary.blue10
    }

    override func adapt(model: WritableReviewCompanyEntity) {
        super.adapt(model: model)
        titleLabel.text = "\(model.name) 면접 후기를 적어 주세요."
    }
}
