import UIKit
import SnapKit
import Then

public final class JobisMenuLabel: UIView {
    private let title = UILabel()
    private let line = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .GrayScale.gray60
    }
    private let subTitle = UILabel().then {
        $0.isHidden = true
    }

    public init(text: String, subText: String? = nil) {
        super.init(frame: .zero)

        self.title.setJobisText(text, font: .description, color: .GrayScale.gray60)
        guard let subText else { return }
        self.subTitle.setJobisText(subText, font: .description, color: .GrayScale.gray60)
        self.line.isHidden = false
        self.subTitle.isHidden = false
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        [
            title,
            line,
            subTitle
        ].forEach(self.addSubview(_:))

        title.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(24)
        }

        line.snp.makeConstraints {
            $0.leading.equalTo(title.snp.trailing).offset(8)
            $0.trailing.equalTo(subTitle.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(1)
        }

        subTitle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
}
