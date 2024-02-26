import UIKit
import Domain
import SnapKit
import Then
import DesignSystem

final class EmploymentCollectionViewCell: BaseCollectionViewCell<TotalPassStudentEntity> {
    static let identifier = "EmploymentCollectionViewCell"
    private let employmentLabel = UILabel().then {
        $0.setJobisText("6기 대마고\n학생들의 취업률", font: .headLine, color: .GrayScale.gray90)
        $0.numberOfLines = 0
    }
    private let employmentPercentageLabel = UILabel().then {
        $0.setJobisText("0.0%", font: .pageTitle, color: .Primary.blue20)
    }
    private let employmentPersonLabel = UILabel().then {
        $0.setJobisText("현재 0/0 명이 취업했어요", font: .description, color: .GrayScale.gray60)
    }
    private let employmentImageView = UIImageView().then {
        $0.image = .jobisIcon(.pieChart)
        $0.contentMode = .scaleToFill
    }

    override func addView() {
        [
            employmentLabel,
            employmentPercentageLabel,
            employmentPersonLabel,
            employmentImageView
        ].forEach(self.addSubview(_:))
    }

    override func setLayout() {
        employmentLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(24)
        }

        employmentPercentageLabel.snp.makeConstraints {
            $0.top.equalTo(employmentLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(24)
        }

        employmentPersonLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(24)
        }

        employmentImageView.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.width.height.equalTo(180)
        }
    }

    override func configureView() {
        self.backgroundColor = .GrayScale.gray30
        self.layer.cornerRadius = 12
    }

    override func adapt(model: TotalPassStudentEntity) {
        let str = String(format: "%.1f", model.passedCount / model.totalStudentCount)

        employmentPercentageLabel.text = "\(str)%"
        employmentPersonLabel.text =
        "현재 \(model.passedCount)/\(model.totalStudentCount) 명이 취업했어요"
        employmentPersonLabel.setRangeOfText(
            font: .jobisFont(.subBody),
            color: .GrayScale.gray70,
            range: "\(model.passedCount)/\(model.totalStudentCount)"
        )
    }
}
