import UIKit
import SnapKit
import Then

public final class RecruitmentDetailLabel: BaseView {
    private let title = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }

    public init(text: String) {
        super.init()
        self.title.setJobisText(text, font: .body, color: .GrayScale.gray90)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func addView() {
        self.addSubview(title)
    }

    public override func setLayout() {
        title.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
    }
}
