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
    private let fieldTypeLabel = UILabel().then {
        $0.setJobisText(
            "프론트엔드 개발자",
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
    private let companyLabel = UILabel().then {
        $0.setJobisText(
            "(주)마이다스아이디",
            font: .description,
            color: UIColor.GrayScale.gray70
        )
    }
    public let bookmarkButton = UIButton().then {
        $0.setImage(.jobisIcon(.bookmarkOff).resize(size: 28), for: .normal)
    }

    override func addView() {
        [
            companyProfileImageView,
            fieldTypeLabel,
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
        fieldTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.equalTo(companyProfileImageView.snp.right).offset(12)
            $0.right.equalToSuperview().inset(52)
        }
        benefitsLabel.snp.makeConstraints {
            $0.top.equalTo(fieldTypeLabel.snp.bottom).offset(4)
            $0.left.equalTo(companyProfileImageView.snp.right).offset(12)
        }
        companyLabel.snp.makeConstraints {
            $0.top.equalTo(benefitsLabel.snp.bottom).offset(4)
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
        fieldTypeLabel.setJobisText(
            model.hiringJobs,
            font: .subHeadLine,
            color: .GrayScale.gray90
        )
        let militarySupport = model.militarySupport ? "O": "X"
        benefitsLabel.setJobisText(
            "병역특례 \(militarySupport) · 실습 수당 \(model.trainPay)만원",
            font: .subBody,
            color: .GrayScale.gray70
        )
        companyLabel.setJobisText(
            model.companyName,
            font: .description,
            color: .GrayScale.gray70
        )
        recruitmentID = model.recruitID
        isBookmarked = model.bookmarked
    }
}
