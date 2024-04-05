import UIKit
import SnapKit
import Then
import DesignSystem

public final class CompanyDetailProfileView: BaseView {
    private let backStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.layoutMargins = .init(top: 12, left: 24, bottom: 12, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    private let profileStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
    }
    private let companyLogoImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.GrayScale.gray30.cgColor
        $0.layer.cornerRadius = 8
    }
    private let companyLabel = UILabel().then {
        $0.setJobisText(
            "기업 상세 불러오는중...",
            font: .headLine,
            color: .GrayScale.gray90
        )
    }
    let companyContentLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .body,
            color: .GrayScale.gray70
        )
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }

    func setCompanyProfile(imageUrl: String, companyName: String, companyContent: String) {
        companyLogoImageView.setJobisImage(urlString: imageUrl)
        companyLabel.text = companyName
        companyContentLabel.text = companyContent
    }

    public override func addView() {
        [
            companyLogoImageView,
            companyLabel
        ].forEach(self.profileStackView.addArrangedSubview(_:))

        [
            profileStackView,
            companyContentLabel
        ].forEach(self.backStackView.addArrangedSubview(_:))
        self.addSubview(backStackView)
    }

    public override func setLayout() {
        companyLogoImageView.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }

        backStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
