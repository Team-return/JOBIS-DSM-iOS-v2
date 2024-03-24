import UIKit
import DesignSystem
import SnapKit
import Then
import Domain
import RxSwift
import RxCocoa

final class AttachmentView: BaseView {
    var removeButtonDidTap: ((Int) -> Void)?
    var urlWillChanged: (((Int, String)) -> Void)?
    private var index: Int?
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
    private let docsNameLabel = UILabel().then {
        $0.setJobisText("", font: .body, color: .GrayScale.gray90)
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
        self.addSubview(backStackView)
        [
            linkImageView,
            docsNameLabel,
            urlTextField,
            removeButton
        ].forEach(backStackView.addArrangedSubview(_:))
    }

    override func setLayout() {
        removeButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }

        linkImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }

        backStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configureView(_ type: AttachedType, data: String, index: Int) {
        super.configureView()
        self.index = index
        linkImageView.isHidden = type == .docs
        urlTextField.isHidden = type == .docs
        docsNameLabel.isHidden = type == .urls
        docsNameLabel.text = data
        urlTextField.text = data
        removeButton.rx.tapGesture()
            .bind { _ in
                self.removeButtonDidTap?(index)
            }
            .disposed(by: disposeBag)
        urlTextField.rx.text.orEmpty.asObservable()
            .distinctUntilChanged()
            .bind(onNext: {
                self.urlWillChanged?((index, $0))
            })
            .disposed(by: disposeBag)
    }
}
