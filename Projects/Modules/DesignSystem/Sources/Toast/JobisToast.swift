import UIKit
import Then
import SnapKit

final class JobisToast: UIStackView {
    private let imageView = UIImageView().then {
        $0.image = DesignSystemAsset.Icons.toastIcon.image
    }
    private let textLabel = UILabel()

    init(text: String) {
        super.init(frame: .zero)
        textLabel.setJobisText(text, font: .subHeadLine, color: .GrayScale.gray90)
        configureView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        self.layer.cornerRadius = 24
        self.layer.borderColor = UIColor.GrayScale.gray40.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .GrayScale.gray30
        self.axis = .horizontal
        self.spacing = 4
        self.layoutMargins = .init(top: 12, left: 16, bottom: 12, right: 16)
        self.isLayoutMarginsRelativeArrangement = true

        [
            imageView,
            textLabel
        ].forEach { self.addArrangedSubview($0) }

        imageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
    }
}
