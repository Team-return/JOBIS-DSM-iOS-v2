import UIKit
import SnapKit

public class JobisLabel: UIView {
    let label = UILabel()
    public init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setLabel(text: String) {
        label.setJobisText(text, font: .description, color: .GrayScale.gray60)
        self.addSubview(label)
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(24)
        }
    }
}
