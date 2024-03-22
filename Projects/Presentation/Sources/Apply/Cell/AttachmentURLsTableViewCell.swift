import UIKit
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa
import Domain
import RxGesture

final class AttachmentURLsTableViewCell: BaseTableViewCell<AttachmentsEntity> {
    static let identifier = "AttachmentURLsTableViewCell"
    public var textFieldWillChanged: ((String) -> Void)?
    public var removeButtonDidTap: (() -> Void)?
    private let disposeBag = DisposeBag()
    private let backStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 12, left: 16, bottom: 12, right: 16)
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .GrayScale.gray30
    }
    private let linkImageView = UIImageView().then {
        $0.image = .jobisIcon(.link).resize(size: 24)
        $0.tintColor = UIColor.GrayScale.gray60
    }
    private let urlTextField = UITextField().then {
        $0.font = .jobisFont(.body)
        $0.placeholder = "링크를 입력해주세요"
        $0.textContentType = .URL
    }
    private let removeButton = UIImageView().then {
        $0.image = .jobisIcon(.close).resize(size: 24)
        $0.tintColor = UIColor.GrayScale.gray60
    }

    override func addView() {
        contentView.addSubview(backStackView)
        [
            linkImageView,
            urlTextField,
            removeButton
        ].forEach(backStackView.addArrangedSubview(_:))
    }

    override func setLayout() {
        linkImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }

        removeButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }

        backStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }
    }

    override func configureView() {
        self.selectionStyle = .none
        urlTextField.rx.text.orEmpty.asObservable()
            .distinctUntilChanged()
            .bind { self.textFieldWillChanged?($0) }
            .disposed(by: disposeBag)
        removeButton.rx.tapGesture().asObservable()
            .bind { _ in
                self.removeButtonDidTap?()
            }
            .disposed(by: disposeBag)
    }

    override func adapt(model: AttachmentsEntity) {
        super.adapt(model: model)
        self.urlTextField.text = model.url
    }
}
