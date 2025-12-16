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
            "-",
            font: .subHeadLine,
            color: UIColor.GrayScale.gray90
        )
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    private let benefitsLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .subBody,
            color: UIColor.GrayScale.gray70
        )
    }
    private let dotLabel = UILabel().then {
        $0.setJobisText(
            "•",
            font: .description,
            color: UIColor.GrayScale.gray70
        )
    }
    private let yearLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .subBody,
            color: UIColor.Primary.blue20
        )
    }
    private let benefitYearStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.alignment = .center
    }
    private let statusTagView = RecruitmentStatusTagView()
    public let bookmarkButton = UIButton().then {
        $0.setImage(.jobisIcon(.bookmarkOff).resize(size: 28), for: .normal)
    }

    override func addView() {
        [
            companyProfileImageView,
            companyLabel,
            benefitYearStackView,
            statusTagView,
            bookmarkButton
        ].forEach {
            contentView.addSubview($0)
        }
        [
            benefitsLabel,
            dotLabel,
            yearLabel
        ].forEach {
            benefitYearStackView.addArrangedSubview($0)
        }
    }

    override func setLayout() {
        companyProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(48)
        }
        statusTagView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(bookmarkButton.snp.leading).offset(-8)
        }
        bookmarkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.width.height.equalTo(28)
        }
        companyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalTo(companyProfileImageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(statusTagView.snp.leading).offset(-8)
        }
        benefitYearStackView.snp.makeConstraints {
            $0.top.equalTo(companyLabel.snp.bottom).offset(4)
            $0.leading.equalTo(companyProfileImageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(statusTagView.snp.leading).offset(-8)
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
        super.adapt(model: model)
        companyProfileImageView.setJobisImage(
            urlString: model.companyProfileURL
        )
        let militarySupport = model.militarySupport ? "O": "X"
        companyLabel.text = model.companyName
        benefitsLabel.text = "병역특례 \(militarySupport)"
        var status: RecruitmentStatus
        if model.status == "RECRUITING" {
            status = .recruiting
        } else {
            status = .done
        }
        let currentYear = Calendar.current.component(.year, from: Date())
        if model.year == currentYear {
            yearLabel.isHidden = true
            dotLabel.isHidden = true
        } else {
            yearLabel.isHidden = false
            dotLabel.isHidden = false
            yearLabel.text = "\(model.year)"
            status = .none
        }
        isBookmarked = model.bookmarked
        statusTagView.configure(with: status)
    }
}
