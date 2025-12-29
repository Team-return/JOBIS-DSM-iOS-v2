import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem
import Charts
import ReactorKit

public final class EmployStatusViewController: BaseReactorViewController<EmployStatusReactor> {
    private let classButtonTapped = PublishRelay<Int>()
    private let filterButton = UIButton(type: .system).then {
        $0.setImage(.jobisIcon(.filterIcon), for: .normal)
        $0.tintColor = .GrayScale.gray90
    }
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let chartView = ChartView()
    private let classEmploymentLabel = UILabel().then {
        $0.setJobisText("반별 취업 현황 확인하기", font: .largeBody, color: .GrayScale.gray60)
    }
    private let softwareDev1Button = ClassButton(icon: "💻", classNumber: 1)
    private let softwareDev2Button = ClassButton(icon: "💻", classNumber: 2)
    private let embeddedDevButton = ClassButton(icon: "🔧", classNumber: 3)
    private let aiDevButton = ClassButton(icon: "🤖", classNumber: 4)
    private lazy var classRow1 = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.distribution = .fillEqually
        $0.addArrangedSubview(softwareDev1Button)
        $0.addArrangedSubview(softwareDev2Button)
    }

    private lazy var classRow2 = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.distribution = .fillEqually
        $0.addArrangedSubview(embeddedDevButton)
        $0.addArrangedSubview(aiDevButton)
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
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        classRow2.snp.makeConstraints {
            $0.top.equalTo(classRow1.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }

    public override func bindAction() {
        viewDidLoadPublisher.asObservable()
            .map { EmployStatusReactor.Action.fetchEmploymentStatus }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        classButtonTapped.asObservable()
            .map { EmployStatusReactor.Action.classButtonTapped($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        filterButton.rx.tap
            .map { EmployStatusReactor.Action.filterButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        [
            softwareDev1Button,
            softwareDev2Button,
            embeddedDevButton,
            aiDevButton
        ]
            .enumerated()
            .forEach { classNumber, button in
                button.rx.tap
                    .map { classNumber + 1 }
                    .bind(to: classButtonTapped)
                    .disposed(by: disposeBag)
            }
    }

    public override func bindState() {
        reactor.state.map { $0.totalPassStudentInfo }
            .bind { [weak self] info in
                self?.chartView.setChartData(model: info)
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        viewWillAppearPublisher
            .bind { [weak self] _ in
                self?.hideTabbar()
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setSmallTitle(title: "취업 현황")

        let rightBarButtonItem = UIBarButtonItem(customView: filterButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem

        filterButton.snp.makeConstraints {
            $0.width.height.equalTo(28)
        }
    }
}
