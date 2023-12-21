import UIKit
import SnapKit
import Then
import Domain
import DesignSystem

final class ApplicationStatusTableViewCell: UITableViewCell {
    static let identifier = "ApplicationStatusTableViewCell"

    public var applicationID: Int?

    private let containerView = UIView().then {
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    private let companyProfileImageView = UIImageView().then {
        $0.image = .jobisIcon(.profile).resize(.init(width: 40, height: 40))
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let companyNameLabel = UILabel()
    private let applicationStatusLabel = UILabel()

    func setCell(_ entity: ApplicationEntity) {
        companyProfileImageView.setJobisImage(urlString: "LOGO_IMAGE/companydefault.png")
        companyNameLabel.setJobisText(entity.company, font: .body, color: .GrayScale.gray90)
        applicationStatusLabel.setJobisText(
            entity.applicationStatus.localizedString(),
            font: .subBody,
            color: entity.applicationStatus.toUIColor()
        )
        self.applicationID = entity.applicationID
    }

    override func layoutSubviews() {
        self.addSubview(containerView)
        [
            companyProfileImageView,
            companyNameLabel,
            applicationStatusLabel
        ].forEach(containerView.addSubview(_:))

        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(64)
        }

        companyProfileImageView.snp.makeConstraints {
            $0.leading.equalTo(containerView).inset(12)
            $0.centerY.equalTo(containerView)
            $0.width.height.equalTo(40)
        }

        companyNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(companyProfileImageView)
            $0.leading.equalTo(companyProfileImageView.snp.trailing).offset(8)
        }

        applicationStatusLabel.snp.makeConstraints {
            $0.centerY.equalTo(companyProfileImageView)
            $0.trailing.equalTo(containerView).inset(16)
        }
    }
}

extension ApplicationStatusType {
    func toUIColor() -> UIColor {
        switch self {
        case .failed, .rejected:
            return .Sub.red

        case .requested, .approved:
            return .Sub.yello

        case .send:
            return .Sub.blue

        case .acceptance, .pass, .fieldTrain:
            return .Sub.green
        }
    }
}
