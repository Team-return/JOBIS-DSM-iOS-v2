import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public enum ReviewTextViewHeight {
    case small
    case medium
    case large

    var value: CGFloat {
        switch self {
        case .small:
            return 48
        case .medium:
            return 120
        case .large:
            return 144
        }
    }
}

public final class ReviewTextView: UIView {
    private var disposeBag = DisposeBag()
    private var heightType: ReviewTextViewHeight = .large

    private let titleLabel = UILabel().then {
        $0.isHidden = true
    }

    private lazy var placeholderLabel: UILabel = UILabel().then {
        $0.numberOfLines = 0
        $0.isUserInteractionEnabled = false
        $0.isHidden = false
        $0.textColor = .GrayScale.gray60
    }

    public let textView = UITextView().then {
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.GrayScale.gray40.cgColor
        $0.font = .jobisFont(.body)
        $0.textColor = .GrayScale.gray90
        $0.textContainerInset = .init(top: 12, left: 12, bottom: 12, right: 12)
    }

    public var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
            updatePlaceholder()
        }
    }

    public var placeholderColor: UIColor = .GrayScale.gray60 {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }

    public init(height: ReviewTextViewHeight = .large) {
        self.heightType = height
        super.init(frame: .zero)
        setupUI()
        setupBinding()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupBinding()
    }

    private func setupUI() {
        addView()
        setLayout()
        setupPlaceholder()

        adjustStyleForHeight()
    }

    private func adjustStyleForHeight() {
        switch heightType {
        case .small:
            textView.textContainerInset = .init(top: 12, left: 12, bottom: 12, right: 12)
        case .medium:
            textView.textContainerInset = .init(top: 12, left: 12, bottom: 12, right: 12)
        case .large:
            textView.textContainerInset = .init(top: 12, left: 12, bottom: 12, right: 12)
        }
    }

    private func setupBinding() {
        textView.rx.text.orEmpty
            .subscribe(onNext: { [weak self] _ in
                self?.updatePlaceholder()
            })
            .disposed(by: disposeBag)
    }

    private func setupPlaceholder() {
        placeholderLabel.font = textView.font

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: textView
        )
        updatePlaceholder()
    }

    @objc private func textDidChange() {
        updatePlaceholder()
    }

    private func updatePlaceholder() {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    public func setTextView(
        title: String? = nil,
        placeholder: String? = nil
    ) {
        if let title = title {
            titleLabel.setJobisText(title, font: .description, color: .GrayScale.gray80)
            titleLabel.isHidden = false
            updateLayoutForTitle()
        } else {
            titleLabel.isHidden = true
            updateLayoutForTitle()
        }

        if let placeholder = placeholder {
            self.placeholder = placeholder
            placeholderLabel.setJobisText(placeholder, font: .body, color: .GrayScale.gray60)
        }
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
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        textView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(heightType.value)
            $0.bottom.equalToSuperview()
        }

        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(12)
        }
    }

    private func updateLayoutForTitle() {
        textView.snp.remakeConstraints {
            if titleLabel.isHidden {
                $0.top.equalToSuperview()
            } else {
                $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            }
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(heightType.value)
            $0.bottom.equalToSuperview()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

public extension ReviewTextView {
    static func small() -> ReviewTextView {
        return ReviewTextView(height: .small)
    }

    static func medium() -> ReviewTextView {
        return ReviewTextView(height: .medium)
    }

    static func large() -> ReviewTextView {
        return ReviewTextView(height: .large)
    }
}
