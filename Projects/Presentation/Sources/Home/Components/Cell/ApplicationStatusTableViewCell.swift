import UIKit
import SnapKit
import Then
import Domain
import DesignSystem
import RxSwift

final class ApplicationStatusTableViewCell: BaseTableViewCell<ApplicationEntity> {
    static let identifier = "ApplicationStatusTableViewCell"
    public var rejectReasonButtonDidTap: ((ApplicationEntity) -> Void)?
    public var reApplyButtonDidTap: ((ApplicationEntity) -> Void)?
    private let disposeBag = DisposeBag()
    private let companyProfileImageView = UIImageView().then {
        $0.image = .jobisIcon(.profile)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let companyNameLabel = UILabel()
    private let stateStackView = UIStackView().then {
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.axis = .horizontal
        $0.spacing = 8
        $0.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    private let applicationStatusLabel = UILabel()
    private let rejectReasonButton = UIButton(type: .system).then {
        $0.setJobisText("사유 보기 →", font: .subBody, color: .Sub.red20)
        $0.setUnderline()
        $0.isHidden = true
    }
    private let reApplyButton = UIButton(type: .system).then {
        $0.setJobisText("재지원 →", font: .subBody, color: .Sub.yellow20)
        $0.setUnderline()
        $0.isHidden = true
    }

    override func addView() {
        contentView.addSubview(stateStackView)

        [
            companyProfileImageView,
            companyNameLabel,
            applicationStatusLabel,
            rejectReasonButton,
            reApplyButton
        ].forEach(stateStackView.addArrangedSubview(_:))
    }

    override func setLayout() {
        companyProfileImageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }

        stateStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }
    }

    override func configureView() {
        rejectReasonButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.rejectReasonButtonDidTap?(owner.model!)
            })
            .disposed(by: disposeBag)

        reApplyButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.reApplyButtonDidTap?(owner.model!)
            })
            .disposed(by: disposeBag)
        self.selectionStyle = .none
    }

    override func adapt(model: ApplicationEntity) {
        super.adapt(model: model)
        companyProfileImageView.setJobisImage(urlString: model.companyLogoUrl)
        companyNameLabel.setJobisText(model.company, font: .body, color: .GrayScale.gray90)
        applicationStatusLabel.setJobisText(
            model.applicationStatus.localizedString(),
            font: .subBody,
            color: model.applicationStatus.toUIColor()
        )
        applicationStatusLabel.snp.contentCompressionResistanceHorizontalPriority = 2
        companyNameLabel.snp.contentCompressionResistanceHorizontalPriority = 1
        rejectReasonButton.isHidden = model.applicationStatus != .rejected
        reApplyButton.isHidden = model.applicationStatus != .requested
        rejectReasonButton.snp.updateConstraints {
            $0.width.lessThanOrEqualTo(rejectReasonButton.intrinsicContentSize.width)
        }
        reApplyButton.snp.updateConstraints {
            $0.width.lessThanOrEqualTo(reApplyButton.intrinsicContentSize.width)
        }
        applicationStatusLabel.snp.updateConstraints {
            $0.width.lessThanOrEqualTo(applicationStatusLabel.intrinsicContentSize.width)
        }
    }
}

private extension ApplicationStatusType {
    func toUIColor() -> UIColor {
        switch self {
        case .failed, .rejected:
            return .Sub.red20

        case .requested, .approved:
            return .Sub.yellow20

        case .send:
            return .Sub.skyBlue20

        case .acceptance, .pass, .fieldTrain:
            return .Sub.green20
        }
    }
}
