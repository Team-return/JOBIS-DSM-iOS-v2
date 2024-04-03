import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class CompanyTableViewCell: BaseTableViewCell<CompanyEntity> {
    static let identifier = "CompanyTableViewCell"
    public var companyID = 0
    private var disposeBag = DisposeBag()
    private var companyProfileImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private var companyNameLabel = UILabel().then {
        $0.setJobisText(
            "㈜마이다스아이티",
            font: .subHeadLine,
            color: .GrayScale.gray90
        )
    }
    private var existRecruitmentLabel = UILabel().then {
        $0.setJobisText(
            "모집의뢰서 O",
            font: .subBody,
            color: .Primary.blue30
        )
    }
    private var benefitLabel = UILabel().then {
        $0.setJobisText(
            "연매출 300억",
            font: .description,
            color: .GrayScale.gray70
        )
    }
    override func addView() {
        [
            companyProfileImageView,
            companyNameLabel,
            existRecruitmentLabel,
            benefitLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }

    override func setLayout() {
        companyProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.width.height.equalTo(48)
        }
        companyNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(companyProfileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(24)
        }
        existRecruitmentLabel.snp.makeConstraints {
            $0.top.equalTo(companyNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(companyProfileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(24)
        }
        benefitLabel.snp.makeConstraints {
            $0.top.equalTo(existRecruitmentLabel.snp.bottom).offset(4)
            $0.leading.equalTo(companyProfileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(24)
        }
    }

    override func configureView() { }

    override func adapt(model: CompanyEntity) {
        companyProfileImageView.setJobisImage(
            urlString: model.logoURL
        )
        companyNameLabel.text = model.name
        let hasRecruitment = model.hasRecruitment ? "O": "X"
        existRecruitmentLabel.text = "모집의뢰서 \(hasRecruitment)"
        benefitLabel.text = "연매출 \(model.take)억"
    }
}
