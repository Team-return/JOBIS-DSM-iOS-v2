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

    override func addView() {
        [
            employPieChartView
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
    }
}
