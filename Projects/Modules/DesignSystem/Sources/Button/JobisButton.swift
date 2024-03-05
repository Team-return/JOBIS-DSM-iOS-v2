import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

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
        guard buttonStyle != .main else { return .white }

        return !isEnabled ? .GrayScale.gray10: .GrayScale.gray90
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
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setText(_ text: String) {
        self.labelText = text
        self.configureUI()
    }

    private func configureUI() {
        let image: UIImage? = .jobisIcon(.arrowRight)
            .withTintColor(fgColor, renderingMode: .alwaysTemplate)
            .resize(size: 24)

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
}

extension JobisButton {
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.backgroundColor = bgColor
    }
}
