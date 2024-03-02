import UIKit
import SnapKit
import Then

public final class CompanyDetailLabel: UIView {
    private let title = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    private let content = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }

    public init(menuText: String, contentText: String) {
        super.init(frame: .zero)

        self.title.setJobisText(menuText, font: .description, color: .GrayScale.gray60)
        self.content.setJobisText(contentText, font: .subBody, color: .GrayScale.gray80)
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
        self.addSubview(content)

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
