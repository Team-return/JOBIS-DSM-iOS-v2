import UIKit
import SnapKit
import Then
import Domain
import DesignSystem

// TODO: 추후 BaseTableViewCell로 변경
final class AlarmTableViewCell: UITableViewCell {
    static let identifier = "AlarmTableViewCell"

    private let companyNameLabel = UILabel()
    private let messageLabel = UILabel()
    private let dateLabel = UILabel()

    func setCell() {
        self.companyNameLabel.setJobisText(
            "㈜비바리퍼블리카",
            font: .description,
            color: .Primary.blue20
        )
        self.messageLabel.setJobisText(
            "지원서가 승인으로 변경되었습니다",
            font: .subHeadLine,
            color: .GrayScale.gray80
        )
        self.dateLabel.setJobisText("2023.07.27", font: .description, color: .GrayScale.gray60)
    }

    override func layoutSubviews() {
        [
            companyNameLabel,
            messageLabel,
            dateLabel
        ].forEach(self.addSubview(_:))

        companyNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(24)
        }

        messageLabel.snp.makeConstraints {
            $0.top.equalTo(companyNameLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(24)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}
