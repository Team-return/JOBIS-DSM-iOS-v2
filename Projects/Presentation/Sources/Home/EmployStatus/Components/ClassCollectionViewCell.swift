import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift

final class ClassCollectionViewCell: BaseCollectionViewCell<EmploymentCompany> {
    static let identifier = "ClassCollectionViewCell"
    private let backView = UIView().then {
        $0.layer.cornerRadius = 6
        $0.backgroundColor = .GrayScale.gray0
        $0.layer.shadowColor = UIColor(red: 112/255, green: 144/255, blue: 176/255, alpha: 0.12).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 8
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.borderWidth = 0.6
        $0.layer.borderColor = UIColor.GrayScale.gray40.cgColor
        $0.clipsToBounds = false
    }

    private let companyImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }

    private let companyNameLabel = UILabel()

    override func configureView() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.clipsToBounds = false
        clipsToBounds = false
    }

    public override func addView() {
        [
            backView,
            companyNameLabel
        ].forEach { contentView.addSubview($0) }
        backView.addSubview(companyImageView)
    }

    public override func setLayout() {
        backView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        companyImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.edges.equalToSuperview().inset(5)
        }
        companyNameLabel.snp.makeConstraints {
            $0.top.equalTo(backView.snp.bottom).offset(8)
            $0.width.equalTo(80)
        }
    }

    override func adapt(model: EmploymentCompany?) {
        if let company = model {
            companyImageView.setJobisImage(urlString: company.logoURL)

            companyNameLabel.setJobisText(company.companyName, font: .caption, color: .GrayScale.gray60)
            companyNameLabel.textAlignment = .center
            companyNameLabel.adjustsFontSizeToFitWidth = true
            companyNameLabel.minimumScaleFactor = 0.1
        } else {
            companyImageView.image = nil
            companyNameLabel.text = ""
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        companyImageView.image = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.layer.shadowPath = nil
    }
}
