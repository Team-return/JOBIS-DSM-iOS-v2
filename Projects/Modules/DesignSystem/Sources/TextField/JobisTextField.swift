import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

public class JobisTextField: UIView {
    private let disposeBag = DisposeBag()

    public var isDescription: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3) { [self] in
                descriptionView.isHidden = !isDescription
            }
        }
    }
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
    private let descriptionView = DescriptionView()

    public init() {
        super.init(frame: .zero)
    }

    public func setTextField(
        title: String,
        placeholder: String,
        descriptionType: DescriptionType = .error(description: ""),
        textFieldRightType: TextFieldType = .none
    ) {
        self.titleLabel.setJobisText(title, font: .description, color: .GrayScale.gray80)
        self.descriptionView.descriptionType = descriptionType
        self.textFieldRightView.textFieldRightType = textFieldRightType
        self.textField.placeholder = placeholder
        self.textFieldRightView.secureButton.rx.tap
            .subscribe(onNext: {
                self.textField.isSecureTextEntry.toggle()
                if self.textField.isSecureTextEntry {
                    self.textFieldRightView.secureButton.setImage(.textFieldIcon(.eyeOff), for: .normal)
                } else {
                    self.textFieldRightView.secureButton.setImage(.textFieldIcon(.eyeOn), for: .normal)
                }
            }).disposed(by: disposeBag)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        addView()
        setLayout()
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
