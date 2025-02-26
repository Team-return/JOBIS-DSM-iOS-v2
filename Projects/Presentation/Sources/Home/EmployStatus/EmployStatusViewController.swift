import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem
import Charts

public final class EmployStatusViewController: BaseViewController<EmployStatusViewModel> {
    private let chartView = ChartView()
    private let classEmploymentLabel = UILabel().then {
        $0.setJobisText("반별 취업 현황 확인하기", font: .largeBody, color: .GrayScale.gray60)
    }

    public override func addView() {
        [
            chartView,
            classEmploymentLabel
        ].forEach { view.addSubview($0) }
    }

    public override func setLayout() {
        chartView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(264)
        }
        classEmploymentLabel.snp.makeConstraints {
            $0.top.equalTo(chartView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bind() {
        let input = EmployStatusViewModel.Input(
            viewWillAppear: viewWillAppearPublisher
        )
        let output = viewModel.transform(input)
        output.totalPassStudentInfo
            .asObservable()
            .bind { [weak self] info in
                self?.chartView.setChartData(model: info)
            }
            .disposed(by: disposeBag)
        viewWillAppearPublisher
            .bind { [weak self] _ in
                self?.hideTabbar()
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setSmallTitle(title: "취업 현황")
    }
}
