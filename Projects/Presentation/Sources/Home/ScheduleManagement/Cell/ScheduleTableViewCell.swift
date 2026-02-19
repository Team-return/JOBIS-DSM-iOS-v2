import UIKit
import SnapKit
import Then
import Domain
import DesignSystem

final class ScheduleTableViewCell: BaseTableViewCell<InterviewScheduleEntity> {
    static let identifier = "ScheduleTableViewCell"

    private let companyNameLabel = UILabel()
    private let contentLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    override func addView() {
        [companyNameLabel, contentLabel].forEach(self.addSubview(_:))
    }

    override func setLayout() {
        companyNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(companyNameLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(20)
        }
    }

    override func configureView() {
        self.selectionStyle = .default
        let selectedView = UIView()
        selectedView.backgroundColor = .GrayScale.gray40
        self.selectedBackgroundView = selectedView
    }

    override func adapt(model: InterviewScheduleEntity) {
        super.adapt(model: model)
        companyNameLabel.setJobisText(model.companyName, font: .subHeadLine, color: .Primary.blue30)
        contentLabel.setJobisText(
            "면접 일정이 \(model.startDate) \(model.interviewTime), \(model.location)으로 예정 되었습니다",
            font: .body,
            color: .GrayScale.gray80
        )
    }
}
