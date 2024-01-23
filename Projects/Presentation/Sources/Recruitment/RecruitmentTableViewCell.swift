import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class RecruitmentTableViewCell: UITableViewCell {
    static let identifier = "RecruitmentTableViewCell"

    var recruitmentID: Int?
    private var disposeBag = DisposeBag()
    private var isBookmarked = false

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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.GrayScale.gray10
        addView()
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func attribute() {
        companyProfileImageView.layer.cornerRadius = 8
        bookmarkButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.bookmark()
            })
            .disposed(by: disposeBag)
    }

    func setCell(_ entity: RecruitmentEntity) {
        companyProfileImageView.setJobisImage(
            urlString: entity.companyProfileURL
        )
        fieldTypeLabel.setJobisText(
            entity.hiringJobs,
            font: .subHeadLine,
            color: .GrayScale.gray90
        )
        let militarySupport = entity.militarySupport ? "O": "X"
        benefitsLabel.setJobisText(
            "병역특례 \(militarySupport) · 실습 수당 \(entity.trainPay)만원",
            font: .subBody,
            color: .GrayScale.gray70
        )
        companyLabel.setJobisText(
            entity.companyName,
            font: .description,
            color: .GrayScale.gray70
        )
        recruitmentID = entity.recruitID
        setBookmark(entity.bookmarked)
    }

    private func setBookmark(_ bool: Bool) {
        self.isBookmarked = bool
        var bookmarkImage: JobisIcon {
            bool ? .bookmarkOn: .bookmarkOff
        }
        bookmarkButton.setImage(
            .jobisIcon(bookmarkImage)
            .resize(size: 28), for: .normal
        )
    }

    func bookmark() {
        setBookmark(!isBookmarked)
    }

    private func addView() {
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

    private func layout() {
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
            $0.right.lessThanOrEqualTo(bookmarkButton.snp.left).offset(-4)
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
}
