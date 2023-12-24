import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

// TODO: configureUI 라는 함수가 너무 커서 isEnabled와 isHighlighted 등 didset에 들어가있으면 값변화가 너무 클 듯 함수를 좀 더 세분화 하는 방향으로..
public final class JobisButton: UIButton {
    private var buttonStyle: JobisButtonStyle = .main
    private var labelText: String = ""

    public override var isHighlighted: Bool {
        didSet { self.configureUI() }
    }

    public override var isEnabled: Bool {
        didSet { self.configureUI() }
    }

    private var fgColor: UIColor {
        guard traitCollection.userInterfaceStyle == .light else { return .black }
        return (buttonStyle == .main || !isEnabled) ? .white: .black
    }

    private var buttonImage: JobisIcon {
        guard traitCollection.userInterfaceStyle == .light else { return .arrowRight(.black) }
        return (buttonStyle == .main || !isEnabled) ? .arrowRight(.white): .arrowRight(.black)
    }

    private var bgColor: UIColor {
        let isDark = traitCollection.userInterfaceStyle == .dark
        if isEnabled {
            switch buttonStyle {
            case .main:
                return isDark ? .Primary.blue20: isHighlighted ? .Primary.blue40: .Primary.blue20
            case .sub:
                return isHighlighted ? .GrayScale.gray40: .GrayScale.gray30
            }
        } else {
            return .GrayScale.gray50
        }
    }

    public init(
        style: JobisButtonStyle
    ) {
        super.init(frame: .zero)
        self.buttonStyle = style

        configureUI()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setText(_ text: String) {
        self.labelText = text
        configureUI()
    }

    private func configureUI() {
        let image: UIImage? = buttonImage.uiImage()
            .resize(.init(width: 24, height: 24))

        var config = UIButton.Configuration.plain()
        config.image = image
        config.title = self.labelText
        config.attributedTitle?.foregroundColor = fgColor
        config.attributedTitle?.font = UIFont.jobisFont(.subHeadLine)
        config.imagePadding = 4
        config.imagePlacement = .trailing
        config.contentInsets = .init(top: 16, leading: 12, bottom: 16, trailing: 0)

        self.configuration = config
        self.layer.cornerRadius = 12
        self.backgroundColor = bgColor
    }

    private func resetUI() {
        self.imageView?.image = buttonImage.uiImage()
            .resize(.init(width: 24, height: 24))
        self.titleLabel?.textColor = fgColor
        self.backgroundColor = bgColor
    }
}

extension JobisButton {
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        resetUI()
    }
}
