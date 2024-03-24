import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class RecruitmentTableViewCell: BaseTableViewCell<RecruitmentEntity> {
    static let identifier = "RecruitmentTableViewCell"
    public var bookmarkButtonDidTap: (() -> Void)?
    public var recruitmentID = 0
    private var disposeBag = DisposeBag()
    private var isBookmarked = false {
        didSet {
            var bookmarkImage: JobisIcon {
                isBookmarked ? .bookmarkOn: .bookmarkOff
            }
            bookmarkButton.setImage(
                .jobisIcon(bookmarkImage)
                .resize(size: 28), for: .normal
            )
        }
    }
    private let companyProfileImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let companyLabel = UILabel().then {
        $0.setJobisText(
            "(주)마이다스아이디",
            font: .subHeadLine,
            color: UIColor.GrayScale.gray90
        )
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    private let benefitsLabel = UILabel().then {
        $0.setJobisText(
            "병역특례 O · 실습 수당 100,000원",
            font: .subBody,
            color: UIColor.GrayScale.gray70
        )
    }
    public let bookmarkButton = UIButton().then {
        $0.setImage(.jobisIcon(.bookmarkOff).resize(size: 28), for: .normal)
    }

    override func addView() {
        [
            companyProfileImageView,
            benefitsLabel,
            companyLabel,
            bookmarkButton
        ].forEach {
            contentView.addSubview($0)
        }
    }

    override func setLayout() {
        companyProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.equalToSuperview().inset(24)
            $0.width.height.equalTo(48)
        }
        bookmarkButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.right.equalToSuperview().inset(24)
        }
        companyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalTo(companyProfileImageView.snp.right).offset(12)
        }
        benefitsLabel.snp.makeConstraints {
            $0.top.equalTo(companyLabel.snp.bottom).offset(4)
            $0.left.equalTo(companyProfileImageView.snp.right).offset(12)
        }
    }

    override func configureView() {
        companyProfileImageView.layer.cornerRadius = 8
        bookmarkButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.bookmarkButtonDidTap?()
                self?.isBookmarked.toggle()
            })
            .disposed(by: disposeBag)
    }

    override func adapt(model: RecruitmentEntity) {
        companyProfileImageView.setJobisImage(
            urlString: model.companyProfileURL
        )
        let militarySupport = model.militarySupport ? "O": "X"
        companyLabel.text = model.companyName
        benefitsLabel.text = "병역특례 \(militarySupport) · 실습 수당 \(model.trainPay)만원"
        recruitmentID = model.recruitID
        isBookmarked = model.bookmarked
    }
}
