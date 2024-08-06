//import UIKit
//import Domain
//import DesignSystem
//import SnapKit
//import Then
//import RxSwift
//import RxCocoa
//
//final class BugReportListTableViewCell: BaseTableViewCell<Any> {
//    static let identifier = "BugReportListTableViewCell"
//    private var disposeBag = DisposeBag()
//
//    private let majorTypeLabel = UILabel().then {
//        $0.setJobisText(
//            "iOS",
//            font: .headLine,
//            color: .Primary.blue20
//        )
//    }
//    private let bugReportListTitleLabel = UILabel().then {
//        $0.setJobisText(
//            "아니 지원서가 두번써짐!",
//            font: .headLine,
//            color: .GrayScale.gray90
//        )
//    }
//    override func addView() {
//        [
//            majorTypeLabel,
//            bugReportListTitleLabel
//        ].forEach {
//            contentView.addSubview($0)
//        }
//    }
//
//    override func setLayout() {
//        majorTypeLabel.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.leading.equalToSuperview().inset(16)
//        }
//
//        bugReportListTitleLabel.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.leading.equalTo(majorTypeLabel.snp.trailing).offset(8)
////            $0.trailing.equalToSuperview().inset(16)
//        }
//    }
//
//    override func configureView() {
//        self.backgroundColor = .GrayScale.gray30
//        self.layer.cornerRadius = 12
//        layoutSubviews()
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4.0, left: 0, bottom: 4.0, right: 0))
//    }
//
////    override func adapt(model: RecruitmentEntity) {
////        super.adapt(model: model)
////        companyProfileImageView.setJobisImage(
////            urlString: model.companyProfileURL
////        )
////        let militarySupport = model.militarySupport ? "O": "X"
////        companyLabel.text = model.companyName
////        benefitsLabel.text = "병역특례 \(militarySupport)"
////        isBookmarked = model.bookmarked
////    }
//}
