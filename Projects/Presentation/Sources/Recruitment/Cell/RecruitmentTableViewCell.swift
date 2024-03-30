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
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(48)
        }
        bookmarkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.width.height.equalTo(28)
        }
        companyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalTo(companyProfileImageView.snp.trailing).offset(12)
            $0.trailing.equalTo(bookmarkButton.snp.leading).offset(4)
        }
        benefitsLabel.snp.makeConstraints {
            $0.top.equalTo(companyLabel.snp.bottom).offset(4)
            $0.leading.equalTo(companyProfileImageView.snp.trailing).offset(12)
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
        isBookmarked = model.bookmarked
    }
}
