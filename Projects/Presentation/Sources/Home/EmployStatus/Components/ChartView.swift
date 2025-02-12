import UIKit
import Domain
import SnapKit
import Then
import DesignSystem
import RxSwift
import DGCharts

final class ChartView: BaseView {
    private let disposeBag = DisposeBag()
    private var employPieChartView = PieChartView().then {
        $0.rotationEnabled = false
        $0.highlightPerTapEnabled = false
        $0.holeRadiusPercent = 0.6
        $0.legend.enabled = false
        let entries = [
            PieChartDataEntry(value: 30, label: ""),
            PieChartDataEntry(value: 70, label: "")
        ]

        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = [.Sub.skyBlue10, .Primary.blue20]
        dataSet.drawValuesEnabled = false

        let data = PieChartData(dataSet: dataSet)
        $0.data = data
    }
    private let employPercentageLabel = UILabel().then {
        $0.setJobisText("70%", font: .subHeadLine, color: .Primary.blue20)
    }
    private let legendView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
    }

    override func addView() {
        [
            employPieChartView,
            legendView
        ].forEach { self.addSubview($0) }
        employPieChartView.addSubview(employPercentageLabel)
    }
    override func setLayout() {
        employPieChartView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(5)
            $0.height.width.equalTo(160)
        }
        employPercentageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        legendView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    override func configureView() {
        super.configureView()
        backgroundColor = .white
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.GrayScale.gray30.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowColor = UIColor(red: 112/255, green: 144/255, blue: 176/255, alpha: 0.12).cgColor
        layer.shadowRadius = 12
        layer.shadowOpacity = 1
        clipsToBounds = false
        setupLegend()
    }

    private func setupLegend() {
        let completedLegend = createLegendItem(color: .Primary.blue20, textColor: .Primary.blue20, text: "취업완료")
        let incompleteLegend = createLegendItem(color: .Sub.skyBlue10, textColor: .GrayScale.gray60, text: "취업 전")

        legendView.addArrangedSubview(completedLegend)
        legendView.addArrangedSubview(incompleteLegend)
    }
    private func createLegendItem(color: UIColor, textColor: UIColor, text: String) -> UIView {
        let containerView = UIView()

        let colorView = UIView()
        colorView.backgroundColor = color
        colorView.layer.cornerRadius = 3

        let label = UILabel()
        label.setJobisText(text, font: .subcaption, color: textColor)

        containerView.addSubview(colorView)
        containerView.addSubview(label)

        containerView.snp.makeConstraints {
            $0.height.equalTo(12)
            $0.width.equalTo(47)
        }
        colorView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(6)
        }

        label.snp.makeConstraints {
            $0.leading.equalTo(colorView.snp.trailing).offset(6)
            $0.centerY.equalToSuperview()
        }

        return containerView
    }
}
