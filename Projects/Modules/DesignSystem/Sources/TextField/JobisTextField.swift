import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

public final class JobisTextField: UIView {
    private var disposeBag = DisposeBag()
    private var timerDisposeBag = DisposeBag()
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
    }
    private let titleLabel = UILabel()
    public let textField = UITextField().then {
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 12
        $0.addLeftPadding(size: 16)
        $0.font = .jobisFont(.body)
    }
    public let textFieldRightView = TextFieldRightStackView()
    private let descriptionView = DescriptionView().then {
        $0.isHidden = true
    }
    private var isDescription = false {
        willSet(newValue) {
            withAnimation {
                self.descriptionView.alpha = newValue ? 1:0
                self.descriptionView.isHidden = !newValue
            }
        }
    }

    public init() {
        super.init(frame: .zero)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func startTimer() {
        timerDisposeBag = DisposeBag()
        textFieldRightView.timeLabel.isHidden = false
        let startTime = Date()
        let timer = Observable<Int>.interval(
            .seconds(1),
            scheduler: MainScheduler.instance
        )
        timer.withUnretained(self)
            .filter { $1 < 300 }
            .subscribe(onNext: { [weak self] _ in
                let elapseSeconds = Date().timeIntervalSince(startTime)
                self?.textFieldRightView.setTimer(Int(elapseSeconds))
            })
            .disposed(by: timerDisposeBag)
    }

    override public func layoutSubviews() {
        addView()
        setLayout()
    }

    public func setTextField(
        title: String,
        placeholder: String,
        descriptionType: DescriptionType? = nil,
        textFieldType: TextFieldType = .none
    ) {
        self.titleLabel.setJobisText(title, font: .description, color: .GrayScale.gray80)
        self.textField.placeholder = placeholder
        if let descriptionType { self.setDescription(descriptionType) }
        self.textFieldRightView.textFieldRightType = textFieldType
        self.setSecureTextField(textFieldType)
    }

    public func setDescription(_ type: DescriptionType) {
        self.isDescription = true
        self.descriptionView.setDescription(descriptionType: type)
        if case .error = type {
            self.textField.rx.text.asDriver()
                .distinctUntilChanged()
                .skip(1)
                .filter { _ in self.isDescription }
                .drive(
                    with: self,
                    onNext: { owner, _ in
                        owner.isDescription = false
                    })
                .disposed(by: disposeBag)
        }
    }

    private func addView() {
        [
            titleLabel,
            textField,
            descriptionView
        ].forEach { self.stackView.addArrangedSubview($0) }
        self.addSubview(stackView)
        self.stackView.setCustomSpacing(4, after: titleLabel)
        self.stackView.setCustomSpacing(8, after: textField)
        self.textField.addSubview(textFieldRightView)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        textField.snp.makeConstraints {
            $0.height.equalTo(52)
        }
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        textFieldRightView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(12)
        }
        textFieldRightView.setLayout()
        textField.addRightPadding(size: textFieldRightView.frame.width + 20)
    }
}

extension JobisTextField {
    private func withAnimation(action: @escaping () -> Void) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations: action
        )
    }

    private func setSecureTextField(_ textFieldType: TextFieldType) {
        self.textField.isSecureTextEntry = textFieldType == .secure ? true : false
        self.textFieldRightView.secureButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.textField.isSecureTextEntry.toggle()
                self?.textFieldRightView
                    .setSecureButtonImage(self?.textField.isSecureTextEntry ?? false)
            }).disposed(by: disposeBag)
    }
}
