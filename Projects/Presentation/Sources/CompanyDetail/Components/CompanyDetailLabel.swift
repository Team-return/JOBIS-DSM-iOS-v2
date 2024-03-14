import UIKit
import SnapKit
import Then

public final class CompanyDetailLabel: BaseView {
    private let title = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    private let content = UILabel().then {
        $0.setJobisText("-", font: .subBody, color: .GrayScale.gray80)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }

    public init(menuText: String) {
        super.init()

        self.title.setJobisText(menuText, font: .subBody, color: .GrayScale.gray80)
    }

    public func setContent(contentText: String) {
        self.content.text = contentText
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func addView() {
        self.addSubview(title)
        self.addSubview(content)
    }

    public override func setLayout() {
        title.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.width.equalTo(64)
        }
        content.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(title.snp.right).offset(8)
            $0.right.equalToSuperview()
        }
    }
}
