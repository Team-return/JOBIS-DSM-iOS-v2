import SnapKit
import Then
import UIKit

public final class JobisRecruitingStatusLabel: UILabel {
    private var padding = UIEdgeInsets(top: 2.5, left: 5, bottom: 2.5, right: 5)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.textAlignment = .center
    }

    public func setStatus(isRecruiting: Bool) {
        if isRecruiting {
            self.setJobisText(
                "지원 가능",
                font: .subcaption,
                color: .Primary.blue20
            )
            self.backgroundColor = .clear
            self.layer.borderColor = UIColor.Primary.blue20.cgColor
        } else {
            self.setJobisText(
                "지원 불가",
                font: .subcaption,
                color: .GrayScale.gray60
            )
            self.backgroundColor = .clear
            self.layer.borderColor = UIColor.GrayScale.gray60.cgColor
        }
    }

    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    public override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
