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
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let chartView = ChartView()
    private let classEmploymentLabel = UILabel().then {
        $0.setJobisText("반별 취업 현황 확인하기", font: .largeBody, color: .GrayScale.gray60)
    }
    private let classButton1 = ClassButton(iconLabel: "💻", classNumber: 1)
    private let classButton2 = ClassButton(iconLabel: "💻", classNumber: 2)
    private let classButton3 = ClassButton(iconLabel: "🔧", classNumber: 3)
    private let classButton4 = ClassButton(iconLabel: "🤖", classNumber: 4)
    private lazy var classRow1 = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.distribution = .fillEqually
    }

    private lazy var classRow2 = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.distribution = .fillEqually
    }

    public override func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            chartView,
            classEmploymentLabel,
            classRow1,
            classRow2
        ].forEach { contentView.addSubview($0) }
        [
            classButton1,
            classButton2
        ].forEach { classRow1.addArrangedSubview($0) }
        [
            classButton3,
            classButton4
        ].forEach { classRow2.addArrangedSubview($0) }
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        chartView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(264)
        }
        classEmploymentLabel.snp.makeConstraints {
            $0.top.equalTo(chartView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        classRow1.snp.makeConstraints {
            $0.top.equalTo(classEmploymentLabel.snp.bottom).offset(7)
            $0.centerX.equalToSuperview()
        }
        classRow2.snp.makeConstraints {
            $0.top.equalTo(classRow1.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
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
