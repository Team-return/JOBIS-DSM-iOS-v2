import UIKit
import SnapKit
import Then
import Domain
import DesignSystem

final class RecentCompanyCollectionViewCell: BaseCollectionViewCell<RecentCompanyItem> {

    static let identifier = "RecentCompanyCollectionViewCell"

    private let companyLogoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.Primary.blue10.cgColor
    }

    private let companyNameLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .subBody,
            color: .GrayScale.gray90
        )
        $0.numberOfLines = 1
    }

    private let recruitingStatusLabel = JobisRecruitingStatusLabel()

    override func addView() {
        [
            companyLogoImageView,
            companyNameLabel,
            recruitingStatusLabel
        ].forEach(contentView.addSubview(_:))
    }

    override func setLayout() {
        companyLogoImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(snp.width).multipliedBy(0.55)
        }

        recruitingStatusLabel.snp.makeConstraints {
            $0.top.equalTo(companyLogoImageView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(8)
        }

        companyNameLabel.snp.makeConstraints {
            $0.top.equalTo(recruitingStatusLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(10)
        }
    }

    override func configureView() {
        self.contentView.backgroundColor = .GrayScale.gray10
        self.contentView.layer.cornerRadius = 12
        
        self.layer.shadowColor = UIColor.GrayScale.gray90.cgColor
        self.layer.shadowOpacity = 0.05
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }

    override func adapt(model: RecentCompanyItem) {
        super.adapt(model: model)
        
        companyNameLabel.text = model.entity.companyName
        companyLogoImageView.setJobisImage(urlString: model.entity.companyLogoURL)
        recruitingStatusLabel.setStatus(isRecruiting: model.entity.isRecruiting)
    }
}
