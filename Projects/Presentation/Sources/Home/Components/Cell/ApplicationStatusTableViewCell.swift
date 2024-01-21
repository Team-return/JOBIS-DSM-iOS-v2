import UIKit
import SnapKit
import Then
import Domain
import DesignSystem
import RxSwift

final class ApplicationStatusTableViewCell: BaseTableViewCell<ApplicationEntity> {
    static let identifier = "ApplicationStatusTableViewCell"
    public var rejectReasonButtonDidTap: (() -> Void)?
    public var applicationID: Int?
    private let disposeBag = DisposeBag()
    private let containerView = UIView().then {
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    private let companyProfileImageView = UIImageView().then {
        $0.image = .jobisIcon(.profile)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let companyNameLabel = UILabel()
    private let stateStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    private let applicationStatusLabel = UILabel()
    private let rejectReasonButton = UIButton(type: .system).then {
        $0.setJobisText("사유 보기 →", font: .subBody, color: .Sub.red20)
        $0.setUnderline()
        $0.isHidden = true
    }

    override func addView() {
        self.addSubview(containerView)
        [
            companyProfileImageView,
            companyNameLabel,
            stateStackView
        ].forEach(containerView.addSubview(_:))

        [
            applicationStatusLabel,
            rejectReasonButton
        ].forEach(stateStackView.addArrangedSubview(_:))
    }

    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(64)
        }

        companyProfileImageView.snp.makeConstraints {
            $0.leading.equalTo(containerView).inset(12)
            $0.centerY.equalTo(containerView)
            $0.width.height.equalTo(40)
        }

        companyNameLabel.snp.contentCompressionResistanceHorizontalPriority = 0
        companyNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(companyProfileImageView)
            $0.leading.equalTo(companyProfileImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(stateStackView.snp.leading).offset(-5)
        }

        stateStackView.snp.makeConstraints {
            $0.centerY.equalTo(companyProfileImageView)
            $0.trailing.equalTo(containerView).inset(16)
        }
    }

    override func configureView() {
        rejectReasonButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.rejectReasonButtonDidTap?()
        }).disposed(by: disposeBag)
        self.selectionStyle = .none
    }

    override func adapt(model: ApplicationEntity) {
        companyProfileImageView.setJobisImage(urlString: "LOGO_IMAGE/companydefault.png")
        companyNameLabel.setJobisText(model.company, font: .body, color: .GrayScale.gray90)
        companyNameLabel.lineBreakMode = .byTruncatingTail
        applicationStatusLabel.setJobisText(
            model.applicationStatus.localizedString(),
            font: .subBody,
            color: model.applicationStatus.toUIColor()
        )
        if model.applicationStatus == .rejected {
            rejectReasonButton.isHidden = false
        }
        self.applicationID = model.applicationID
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
