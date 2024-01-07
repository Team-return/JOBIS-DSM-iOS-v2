import UIKit
import Then
import SnapKit

final class JobisToast: UIView {
    private let imageView = UIImageView().then {
        $0.image = DesignSystemAsset.Icons.toastIcon.image
    }
    private let textLabel = UILabel()

    init(text: String) {
        super.init(frame: .zero)
        textLabel.setJobisText(text, font: .subHeadLine, color: .GrayScale.gray90)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        self.layer.cornerRadius = 24
        self.layer.borderColor = UIColor.GrayScale.gray40.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .GrayScale.gray30

        [
            imageView,
            textLabel
        ].forEach { self.addSubview($0) }

        imageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(12)
            $0.width.height.equalTo(24)
        }
        textLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalTo(imageView.snp.trailing).offset(4)
        }
    }
}
