import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class ReviewTableViewCell: BaseTableViewCell<ReviewEntity> {
    static let identifier = "ReviewTableViewCell"
    private var disposeBag = DisposeBag()
    private let companyProfileImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let companyLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .subHeadLine,
            color: UIColor.GrayScale.gray90
        )
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    private let contentLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .description,
            color: UIColor.Primary.blue20
        )
    }

    override func addView() {
        [
            companyProfileImageView,
            companyLabel,
            contentLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }

    override func setLayout() {
        companyProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(48)
        }
        companyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalTo(companyProfileImageView.snp.trailing).offset(12)
        }
        contentLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.leading.equalTo(companyProfileImageView.snp.trailing).offset(12)
        }
    }

    override func configureView() {
        companyProfileImageView.layer.cornerRadius = 8
    }

    override func adapt(model: ReviewEntity) {
        super.adapt(model: model)
        companyProfileImageView.setJobisImage(
            urlString: model.companyProfileURL
        )
        companyLabel.text = model.companyName
        contentLabel.text = "\(model.major) • \(model.writer)"
    }
}
