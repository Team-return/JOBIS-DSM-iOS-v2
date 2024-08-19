import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

public final class JobisTextView: UIView {
    private var disposeBag = DisposeBag()
    private let titleLabel = UILabel()
    private var placeholderLabel = UILabel().then {
        $0.isHidden = false
    }
    public let textView = UITextView().then {
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 12
        $0.font = .jobisFont(.body)
        $0.textColor = .GrayScale.gray90
        $0.textContainerInset = .init(top: 12, left: 12, bottom: 12, right: 12)
    }

    public init() {
        super.init(frame: .zero)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        addView()
        setLayout()
    }

    public func setTextField(
        title: String,
        placeholder: String
    ) {
        self.titleLabel.setJobisText(title, font: .description, color: .GrayScale.gray60)
        self.placeholderLabel.setJobisText(placeholder, font: .body, color: .GrayScale.gray60)
        self.textView.rx.text.orEmpty.asObservable()
            .map { $0.isEmpty }
            .bind(onNext: { self.placeholderLabel.isHidden = !$0 })
            .disposed(by: disposeBag)
    }

    private func addView() {
        [
            titleLabel,
            textView
        ].forEach(self.addSubview(_:))

        textView.addSubview(placeholderLabel)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(24)
        }

        textView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(144)
            $0.bottom.equalToSuperview().inset(12)
        }

        placeholderLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.top.equalToSuperview().inset(10)
        }
    }
}
