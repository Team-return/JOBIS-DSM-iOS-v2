import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

public final class JobisCheckBox: UIButton {
    public var isCheck: Bool = false {
        didSet { self.configureUI() }
    }

    private var fgColor: UIColor {
        return isCheck ? .GrayScale.gray10: .GrayScale.gray50
    }

    private var bgColor: UIColor {
        return isCheck ? .Primary.blue20: .GrayScale.gray30
    }

    public init() {
        super.init(frame: .zero)
        configureUI()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        let image: UIImage? = .jobisIcon(.arrowDown)
            .withTintColor(fgColor, renderingMode: .alwaysTemplate)
            .resize(size: 28)

        var config = UIButton.Configuration.plain()
        config.image = image
        config.imagePlacement = .all
        self.configuration = config
        self.layer.cornerRadius = 4
        self.backgroundColor = bgColor
    }
}
