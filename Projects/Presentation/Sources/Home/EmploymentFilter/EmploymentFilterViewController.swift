import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class EmploymentFilterViewController: BaseViewController<EmploymentFilterViewModel> {
    private let selectedYearRelay = BehaviorRelay<String?>(value: nil)

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }

    private let yearSectionView = UIView()
    private lazy var yearStackView = YearSelectionView()

    private let filterApplyButton = JobisButton(style: .main).then {
        $0.setText("적용하기")
    }

    public override func addView() {
        [
            scrollView,
            filterApplyButton
        ].forEach { view.addSubview($0) }
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(yearSectionView)
        yearSectionView.addSubview(yearStackView)
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(filterApplyButton.snp.top)
        }

        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        yearSectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        yearStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }

        filterApplyButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            $0.height.equalTo(48)
        }
    }

    public override func bind() {
        let years = ["2025", "2024"]
        yearStackView.setYears(years)

        yearStackView.selectedYearObservable
            .bind(to: selectedYearRelay)
            .disposed(by: disposeBag)

        let input = EmploymentFilterViewModel.Input(
            viewAppear: viewWillAppearPublisher,
            applyButtonDidTap: filterApplyButton.rx.tap
                .withLatestFrom(selectedYearRelay.asObservable())
                .compactMap { $0 }
                .map { Int($0) ?? Calendar.current.component(.year, from: Date()) }
                .asSignal(onErrorJustReturn: Calendar.current.component(.year, from: Date()))
        )

        let output = viewModel.transform(input)
    }

    public override func configureNavigation() {
        setSmallTitle(title: "년도 설정")
    }
}
