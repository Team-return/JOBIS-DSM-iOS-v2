import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

public class JobisButton: UIButton {
    private var buttonStyle: JobisButtonStyle = .main
    private var labelText: String = ""

    public override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted

            self.configureUI()
        }
    }

    public override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled

            self.configureUI()
        }
    }

    private func backgroundColor() -> UIColor {
        if isEnabled {
            switch buttonStyle {
            case .main:
                return isHighlighted ? .Main.blue3: .Main.blue1
            case .sub:
                return isHighlighted ? .GrayScale.gray40: .GrayScale.gray30
            }
        } else {
            return .GrayScale.gray50
        }
    }

    private func foregroundColor() -> UIColor {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark

        if !isEnabled || buttonStyle == .main {
            return isDarkMode ? .GrayScale.gray90: .GrayScale.gray10
        } else {
            return .GrayScale.gray90
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
        let fgColor = foregroundColor()
        let image: UIImage? = .jobisIcon(.arrowRight)
            .withTintColor(fgColor, renderingMode: .alwaysOriginal)
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
        self.backgroundColor = backgroundColor()
    }
}
