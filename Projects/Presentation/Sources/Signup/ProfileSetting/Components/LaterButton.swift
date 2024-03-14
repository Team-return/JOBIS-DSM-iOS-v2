import UIKit
import DesignSystem
import Then
import SnapKit

final class LaterButton: UIButton {
    private let textLabel = UILabel().then {
        $0.setJobisText("다음에 하기 →", font: .body, color: .GrayScale.gray70)
    }

    init() {
        super.init(frame: .zero)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addView()
        setLayout()
    }

    private func addView() {
        self.addSubview(textLabel)
    }

    private func setLayout() {
        textLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(12)
        }
    }
    private func configureView() {
        self.layer.cornerRadius = 24
        self.backgroundColor = .GrayScale.gray30
    }
}
