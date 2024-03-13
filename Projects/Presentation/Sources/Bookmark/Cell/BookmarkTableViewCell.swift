import UIKit
import Domain
import SnapKit
import Then
import DesignSystem
import RxSwift
import RxCocoa

class BookmarkTableViewCell: BaseTableViewCell<BookmarkEntity> {
    static let identifier = "BookmarkTableViewCell"
    public var trashButtonDidTap: (() -> Void)?
    private let disposeBag = DisposeBag()
    private let companyImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let companyNameLabel = UILabel()
    private let dateLabel = UILabel()
    private let trashButton = UIButton(type: .system).then {
        $0.setImage(.jobisIcon(.trash), for: .normal)
        $0.tintColor = .GrayScale.gray60
    }

    override func addView() {
        [
            companyImageView,
            companyNameLabel,
            dateLabel,
            trashButton
        ].forEach(self.contentView.addSubview(_:))
    }

    override func setLayout() {
        companyImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.top.bottom.equalToSuperview().inset(16)
            $0.width.equalTo(48)
        }

        companyNameLabel.snp.makeConstraints {
            $0.leading.equalTo(companyImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(trashButton.snp.leading).offset(-10)
            $0.top.equalToSuperview().inset(16)
        }

        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(companyImageView.snp.trailing).offset(8)
            $0.top.equalTo(companyNameLabel.snp.bottom).offset(4)
        }

        trashButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(32)
            $0.centerY.equalToSuperview()
        }
    }

    override func configureView() {
        self.selectionStyle = .none
        trashButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.trashButtonDidTap?()
            })
            .disposed(by: disposeBag)
    }

    override func adapt(model: BookmarkEntity) {
        super.adapt(model: model)
        self.companyImageView.setJobisImage(urlString: model.companyLogoUrl)
        self.companyNameLabel.setJobisText(model.companyName, font: .body, color: .GrayScale.gray90)
        self.dateLabel.setJobisText(model.createdAt, font: .description, color: .GrayScale.gray70)
    }
}
