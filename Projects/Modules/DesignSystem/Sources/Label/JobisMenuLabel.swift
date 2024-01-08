import UIKit
import SnapKit

public final class JobisMenuLabel: UIView {
    private let title = UILabel()

    public init(text: String) {
        super.init(frame: .zero)

        title.setJobisText(text, font: .description, color: .GrayScale.gray60)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        self.addSubview(title)

        title.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(24)
        }
    }
}
