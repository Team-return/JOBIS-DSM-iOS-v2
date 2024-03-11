import UIKit
import SnapKit
import Then
import DesignSystem

public final class RecruitmentDetailLabel: BaseView {
    private let titleLabel: JobisMenuLabel
    private let subTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }

    public init(title: String) {
        self.titleLabel = JobisMenuLabel(text: title)
        super.init()
        self.subTitleLabel.setJobisText("-", font: .body, color: .GrayScale.gray90)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func addView() {
        [
            titleLabel,
            subTitleLabel
        ].forEach(self.addSubview(_:))
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(16)
        }
    }

    public func setSubTitle(_ subTitle: String?) {
        self.subTitleLabel.setJobisText(subTitle ?? "-", font: .body, color: .GrayScale.gray90)
    }
}
