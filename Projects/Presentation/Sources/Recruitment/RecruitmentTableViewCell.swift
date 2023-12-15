import UIKit
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class RecruitmentTableViewCell: UITableViewCell {
    static let identifier = "RecruitmentTableViewCell"

    private var disposeBag = DisposeBag()
    private var isBookmarked: Bool = false
    private let companyLogo = UIImageView().then {
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 8
    }
    private let fieldTypeLabel = UILabel().then {
        $0.setJobisText(
            "프론트엔드 개발자",
            font: .subHeadLine,
            color: UIColor.GrayScale.gray90
        )
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
    private let bookmarkButton = UIButton().then {
        $0.setImage(
            .jobisIcon(.bookmarkOff)
            .resize(.init(width: 28, height: 28)),
            for: .normal
        )
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
        bookmarkButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                bookmark()
            })
            .disposed(by: disposeBag)
    }

    private func bookmark() {
        var bookmarkImage: JobisIcon {
            isBookmarked ? .bookmarkOn: .bookmarkOff
        }
        bookmarkButton.setImage(
            .jobisIcon(bookmarkImage)
            .resize(.init(width: 28, height: 28)),
            for: .normal
        )
        isBookmarked.toggle()
    }

    private func addView() {
        [
            companyLogo,
            fieldTypeLabel,
            benefitsLabel,
            companyLabel,
            bookmarkButton
        ].forEach {
            contentView.addSubview($0)
        }
    }

    private func layout() {
        companyLogo.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.equalToSuperview().inset(24)
            $0.width.height.equalTo(48)
        }
        fieldTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.equalTo(companyLogo.snp.right).offset(12)
        }
        benefitsLabel.snp.makeConstraints {
            $0.top.equalTo(fieldTypeLabel.snp.bottom).offset(4)
            $0.left.equalTo(companyLogo.snp.right).offset(12)
        }
        companyLabel.snp.makeConstraints {
            $0.top.equalTo(benefitsLabel.snp.bottom).offset(4)
            $0.left.equalTo(companyLogo.snp.right).offset(12)
        }
        bookmarkButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.right.equalToSuperview().inset(24)
        }
    }
}
