import UIKit
import DesignSystem
import Then
import SnapKit

final class ForgetPasswordButton: BaseView {
    private let imageView = UIImageView().then {
        $0.image = .jobisIcon(.renewal)
        $0.tintColor = .GrayScale.gray70
    }
    private let textLabel = UILabel().then {
        $0.setJobisText("비밀번호를 잊으셨나요?", font: .body, color: .GrayScale.gray70)
    }

    override func addView() {
        [
            imageView,
            textLabel
        ].forEach { self.addSubview($0) }
    }

    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(24)
        }
        textLabel.snp.makeConstraints {
            $0.centerY.equalTo(imageView)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(imageView.snp.trailing).offset(4)
        }
    }

    override func configureView() {
        self.layer.cornerRadius = 24
        self.backgroundColor = .GrayScale.gray30
        self.clipsToBounds = true
    }
}
