import UIKit
import Domain
import SnapKit
import Then
import DesignSystem
import RxSwift
import DGCharts

final class ChartView: BaseView {
    private let disposeBag = DisposeBag()
    private let chartContainerView = UIView()
    private var employPieChartView = PieChartView().then {
        $0.rotationEnabled = false
        $0.highlightPerTapEnabled = false
        $0.holeRadiusPercent = 0.6
        $0.legend.enabled = false
        let entries = [
            PieChartDataEntry(value: 100, label: ""),
            PieChartDataEntry(value: 0, label: "")
        ]

        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = [.Sub.skyBlue10, .Primary.blue20]
        dataSet.drawValuesEnabled = false
        dataSet.selectionShift = 0

        let data = PieChartData(dataSet: dataSet)
        $0.data = data
    }
    private let employPercentageLabel = UILabel().then {
        $0.setJobisText("\(0)%", font: .boldBody, color: .Primary.blue20)
    }
    private let employLabel = UILabel().then {
        $0.setJobisText("취업 현황", font: .subBody, color: .Sub.skyBlue30)
    }
    private let stickView = UIView().then {
        $0.backgroundColor = .GrayScale.gray40
        $0.layer.cornerRadius = 7
    }
    private let totalStatsLabel = UILabel().then {
        $0.setJobisText("전체 통계", font: .description, color: .Sub.skyBlue30)
    }
    private let totalStatsValueLabel = UILabel().then {
        $0.setJobisText("\(0)/\(0)명", font: .description, color: .Primary.blue20)
    }
    private let completedLegend = LegendView().then {
        $0.setup(color: .Primary.blue20, textColor: .Primary.blue20, text: "취업완료")
    }
    private let incompleteLegend = LegendView().then {
        $0.setup(color: .Sub.skyBlue10, textColor: .GrayScale.gray60, text: "취업 전")
    }
    private let legendView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
    }
    override func addView() {
        [
            chartContainerView,
            employLabel,
            legendView,
            totalStatsLabel,
            totalStatsValueLabel
        ].forEach { self.addSubview($0) }
        [
            employPieChartView,
            stickView,
            totalStatsLabel,
            totalStatsValueLabel
        ].forEach { chartContainerView.addSubview($0) }
        employPieChartView.addSubview(employPercentageLabel)
        legendView.addArrangedSubview(completedLegend)
        legendView.addArrangedSubview(incompleteLegend)
    }
    override func setLayout() {
        chartContainerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(120)
            $0.width.equalTo(215)
        }

        employPieChartView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.width.equalTo(120)
        }

        stickView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(employPieChartView.snp.trailing).offset(16)
            $0.height.equalTo(30)
            $0.width.equalTo(1)
        }

        totalStatsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(38)
            $0.centerX.equalTo(totalStatsValueLabel)
        }

        totalStatsValueLabel.snp.makeConstraints {
            $0.top.equalTo(totalStatsLabel.snp.bottom).offset(8)
            $0.leading.equalTo(stickView.snp.trailing).offset(21)
        }

        employPercentageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        employLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(16)
        }

        legendView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(28)
            $0.width.equalTo(47)
        }
    }
    override func configureView() {
        super.configureView()
        backgroundColor = .GrayScale.gray10
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.GrayScale.gray30.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowColor = UIColor(red: 112/255, green: 144/255, blue: 176/255, alpha: 0.12).cgColor
        layer.shadowRadius = 12
        layer.shadowOpacity = 1
        clipsToBounds = false
    }
}
