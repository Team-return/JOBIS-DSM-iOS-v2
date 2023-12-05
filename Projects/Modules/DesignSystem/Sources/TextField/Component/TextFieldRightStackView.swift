import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

public class TextFieldRightStackView: UIStackView {
    private let disposeBag = DisposeBag()
    public var textFieldRightType: TextFieldType = .none {
        didSet {
            switch textFieldRightType {
            case .email:
                emailInfoLabel.isHidden = false
            case let .emailWithbutton(buttonTitle):
                emailInfoLabel.isHidden = false
                customButton.isHidden = false
                setCustomButtonTitle(title: buttonTitle)
            case .secure:
                secureButton.isHidden = false
            case .time:
                timeLabel.isHidden = false
            case .none:
                return
            }
        }
    }
    public func setCustomButtonTitle(title: String) {
        customButton.isHidden = false
        customButton.configuration?.title = title
        customButton.configuration?.attributedTitle?.font = .jobisFont(.subBody)
    }
    public let secureButton = UIButton(type: .system).then {
        $0.setImage(.textFieldIcon(.eyeOff), for: .normal)
        $0.tintColor = UIColor.GrayScale.gray60
        $0.isHidden = true
    }
    public let customButton = UIButton(type: .system).then {
        $0.isHidden = true
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .Main.blue1
        config.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
        $0.configuration = config
        $0.backgroundColor = DesignSystemAsset.Main.bg.color
        $0.layer.cornerRadius = 8
    }
    public let emailInfoLabel = UILabel().then {
        $0.setJobisText("@dsm.hs.kr", font: .body, color: .GrayScale.gray60)
        $0.isHidden = true
    }
    public let timeLabel = UILabel().then {
        $0.isHidden = true
    }

    public init() {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.alignment = .fill
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setTimer(_ time: Int) {
        let minuites = ((300 - time).secondToMinutes())
        timeLabel.setJobisText(minuites, font: .body, color: .GrayScale.gray60)
    }
    public func setLayout() {
        [
            emailInfoLabel,
            secureButton,
            customButton,
            timeLabel
        ].forEach { self.addArrangedSubview($0) }

        secureButton.snp.makeConstraints {
            $0.width.equalTo(24)
        }
        self.setCustomSpacing(8, after: emailInfoLabel)
    }
}
