import UIKit
import SnapKit
import Then

public final class RecruitmentDetailLabel: UIView {
    private let title = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }

    public init(text: String) {
        super.init(frame: .zero)

        self.title.setJobisText(text, font: .body, color: .GrayScale.gray90)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        self.addSubview(title)

        title.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
    }
}
