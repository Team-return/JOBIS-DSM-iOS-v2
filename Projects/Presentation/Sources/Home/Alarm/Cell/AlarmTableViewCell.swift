import UIKit
import SnapKit
import Then
import Domain
import DesignSystem

final class AlarmTableViewCell: BaseTableViewCell<NotificationEntity> {
    static let identifier = "AlarmTableViewCell"
    private let companyNameLabel = UILabel()
    private let messageLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    private let dateLabel = UILabel()
    private let readStateView = UIView().then {
        $0.backgroundColor = .Sub.red20
        $0.layer.cornerRadius = 2
        $0.clipsToBounds = true
        $0.isHidden = true
    }

    override func addView() {
        [
            companyNameLabel,
            messageLabel,
            dateLabel,
            readStateView
        ].forEach(self.addSubview(_:))
    }

    override func setLayout() {
        companyNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        messageLabel.snp.makeConstraints {
            $0.top.equalTo(companyNameLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(16)
        }

        readStateView.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(4)
            $0.width.height.equalTo(4)
        }
    }

    override func configureView() {
        self.selectionStyle = .none
    }

    override func adapt(model: NotificationEntity) {
        super.adapt(model: model)
        self.companyNameLabel.setJobisText(
            model.title,
            font: .description,
            color: .Primary.blue30
        )
        self.messageLabel.setJobisText(
            model.content,
            font: .subHeadLine,
            color: .GrayScale.gray80
        )
        self.dateLabel.setJobisText(
            model.createdAt,
            font: .description,
            color: .GrayScale.gray60
        )
        readStateView.isHidden = !model.new
    }
}
