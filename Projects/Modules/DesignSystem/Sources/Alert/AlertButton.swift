import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

final class AlertButton: UIButton {
    private var buttonStyle: AlertButtonStyle = .cancel
    private var labelText: String = ""

    init(
        style: AlertButtonStyle
    ) {
        super.init(frame: .zero)
        self.buttonStyle = style
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setText(_ text: String) {
        self.labelText = text
        self.configureUI()
    }

    private func configureUI() {
        let image: UIImage? = .jobisIcon(.arrowRight)
            .withTintColor(buttonStyle.foregroundColor, renderingMode: .alwaysTemplate)
            .resize(size: 24)

        var config = UIButton.Configuration.plain()
        config.image = image
        config.title = self.labelText
        config.attributedTitle?.foregroundColor = buttonStyle.foregroundColor
        config.attributedTitle?.font = UIFont.jobisFont(.subHeadLine)
        config.imagePadding = 4
        config.imagePlacement = .trailing
        config.contentInsets = .init(top: 16, leading: 12, bottom: 16, trailing: 0)

        self.configuration = config
        self.layer.cornerRadius = 12
        self.backgroundColor = buttonStyle.backgroundColor
    }
}
