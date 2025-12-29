import UIKit
import SnapKit
import Then
import Domain
import DesignSystem
import RxSwift

final class InterviewReviewTableViewCell: BaseTableViewCell<ReviewEntity> {
    static let identifier = "InterviewReviewTableViewCell"

    public var interviewReviewID: Int?
    private let disposeBag = DisposeBag()

    private let containerView = UIView().then {
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    let interviewReviewLabel = UILabel().then {
        $0.setJobisText(
            "길강민님의 후기",
            font: .subHeadLine,
            color: .GrayScale.gray90
        )
    }
    var interviewReviewYearLabel = UILabel().then {
        $0.setJobisText(
            "2022",
            font: .description,
            color: .GrayScale.gray60
        )
    }
    let interviewReviewArrowImageViwe = UIImageView().then {
        $0.image = .jobisIcon(.arrowRight)
        $0.image = UIImage(systemName: "arrow.right")
        $0.tintColor = .GrayScale.gray60
    }

    override func addView() {
        self.addSubview(containerView)
        [
            interviewReviewLabel,
            interviewReviewYearLabel,
            interviewReviewArrowImageViwe
        ].forEach(containerView.addSubview(_:))
    }

    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24)
        }
        interviewReviewLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(containerView).inset(16)
        }
        interviewReviewYearLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(interviewReviewLabel.snp.right).offset(8)
        }
        interviewReviewArrowImageViwe.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.right.equalTo(containerView).inset(16)
        }
    }

    override func configureView() {
        self.selectionStyle = .none
    }

    public override func adapt(model: ReviewEntity) {
        interviewReviewLabel.setJobisText(
            model.writer + "님의 후기",
            font: .subHeadLine,
            color: .GrayScale.gray90
        )
        interviewReviewYearLabel.text = String(model.year)
    }
}
