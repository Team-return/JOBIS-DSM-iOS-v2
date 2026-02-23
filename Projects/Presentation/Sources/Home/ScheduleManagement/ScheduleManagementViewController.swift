import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class ScheduleManagementViewController: BaseReactorViewController<ScheduleManagementReactor> {

    private let topStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }

    private let tabWrapperView = UIView()
    private let tabContainerView = UIView().then {
        $0.backgroundColor = .GrayScale.gray20
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    private let calendarTabButton = UIButton().then {
        $0.setJobisText("캘린더", font: .subBody, color: .GrayScale.gray90)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let editTabButton = UIButton().then {
        $0.setJobisText("수정", font: .subBody, color: .GrayScale.gray60)
        $0.backgroundColor = .clear
    }

    private let calendarSectionView = UIView()
    private let calendarView = CalendarView()
    private let calendarDivider = UIView().then {
        $0.backgroundColor = .GrayScale.gray20
    }

    private let editSectionView = UIView().then {
        $0.isHidden = true
    }
    private let editTitleLabel = UILabel().then {
        $0.setJobisText("예정된 면접", font: .subHeadLine, color: .GrayScale.gray90)
    }
    private let editLineDivider = UIView().then {
        $0.backgroundColor = .GrayScale.gray30
    }

    private let scheduleTableView = UITableView().then {
        $0.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 90
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }

    private let addScheduleButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = .white
        $0.backgroundColor = .Primary.blue20
        $0.layer.cornerRadius = 26
        $0.clipsToBounds = true
    }

    private let changeButtonContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.isHidden = true
    }
    private let changeButton = JobisButton(style: .main).then {
        $0.setText("수정하기")
    }

    private var hasSetupLayout = false

    public override func addView() {
        guard !hasSetupLayout else { return }
        [calendarTabButton, editTabButton].forEach(tabContainerView.addSubview(_:))
        tabWrapperView.addSubview(tabContainerView)

        [calendarView, calendarDivider].forEach(calendarSectionView.addSubview(_:))
        [editTitleLabel, editLineDivider].forEach(editSectionView.addSubview(_:))

        [tabWrapperView, calendarSectionView, editSectionView]
            .forEach(topStackView.addArrangedSubview(_:))

        changeButtonContainerView.addSubview(changeButton)
        [topStackView, scheduleTableView, changeButtonContainerView, addScheduleButton].forEach(view.addSubview(_:))
    }

    public override func setLayout() {
        guard !hasSetupLayout else { return }
        hasSetupLayout = true

        topStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        tabContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview()
        }
        calendarTabButton.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(4)
            $0.width.equalToSuperview().multipliedBy(0.5).offset(-4)
        }
        editTabButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview().inset(4)
            $0.width.equalToSuperview().multipliedBy(0.5).offset(-4)
        }

        calendarView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(380)
        }
        calendarDivider.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)
            $0.bottom.equalToSuperview()
        }

        editTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        editLineDivider.snp.makeConstraints {
            $0.top.equalTo(editTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }

        scheduleTableView.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }

        addScheduleButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(28)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(18)
            $0.width.height.equalTo(52)
        }

        changeButtonContainerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        changeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(52)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }

    public override func bindAction() {
        calendarTabButton.rx.tap
            .map { ScheduleManagementReactor.Action.calendarTabDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        editTabButton.rx.tap
            .map { ScheduleManagementReactor.Action.editTabDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        calendarView.prevMonthTapped
            .map { ScheduleManagementReactor.Action.prevMonthDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        calendarView.nextMonthTapped
            .map { ScheduleManagementReactor.Action.nextMonthDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        calendarView.daySelected
            .map { ScheduleManagementReactor.Action.dayDidSelect($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        scheduleTableView.rx.itemSelected
            .map { ScheduleManagementReactor.Action.scheduleDidSelect($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        addScheduleButton.rx.tap
            .map { ScheduleManagementReactor.Action.addScheduleDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        let state = reactor.state.share()

        state
            .distinctUntilChanged {
                $0.currentYear == $1.currentYear
                    && $0.currentMonth == $1.currentMonth
                    && $0.selectedDay == $1.selectedDay
            }
            .bind { [weak self] state in
                self?.calendarView.configure(
                    year: state.currentYear,
                    month: state.currentMonth,
                    today: state.todayDay,
                    selectedDay: state.selectedDay
                )
            }
            .disposed(by: disposeBag)

        state.map { $0.scheduleList }
            .bind(to: scheduleTableView.rx.items(
                cellIdentifier: ScheduleTableViewCell.identifier,
                cellType: ScheduleTableViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
            }
            .disposed(by: disposeBag)

        state.map { $0.selectedTab }
            .distinctUntilChanged()
            .bind { [weak self] tab in
                self?.updateTabAppearance(tab)
            }
            .disposed(by: disposeBag)

        state.map { $0.selectedScheduleIndex }
            .distinctUntilChanged()
            .bind { [weak self] index in
                guard let self else { return }
                if let index {
                    self.scheduleTableView.selectRow(
                        at: IndexPath(row: index, section: 0),
                        animated: true,
                        scrollPosition: .none
                    )
                    self.changeButton.isEnabled = true
                } else {
                    self.scheduleTableView.indexPathsForSelectedRows?.forEach {
                        self.scheduleTableView.deselectRow(at: $0, animated: true)
                    }
                    self.changeButton.isEnabled = false
                }
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        viewWillAppearPublisher.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.hideTabbar()
            })
            .disposed(by: disposeBag)

        viewWillAppearPublisher.asObservable()
            .map { ScheduleManagementReactor.Action.fetchScheduleList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setSmallTitle(title: "일정 관리")
    }

    private func updateTabAppearance(_ tab: ScheduleManagementReactor.TabType) {
        let isCalendar = tab == .calendar

        calendarSectionView.isHidden = !isCalendar
        editSectionView.isHidden = isCalendar
        changeButtonContainerView.isHidden = isCalendar
        addScheduleButton.isHidden = !isCalendar
        scheduleTableView.contentInset.bottom = isCalendar ? 0 : 84

        UIView.animate(withDuration: 0.2) {
            self.calendarTabButton.backgroundColor = isCalendar ? .white : .clear
            self.editTabButton.backgroundColor = isCalendar ? .clear : .white
            self.calendarTabButton.setJobisText(
                "캘린더",
                font: .subBody,
                color: isCalendar ? .GrayScale.gray90 : .GrayScale.gray60
            )
            self.editTabButton.setJobisText(
                "수정",
                font: .subBody,
                color: isCalendar ? .GrayScale.gray60 : .GrayScale.gray90
            )
        }
    }
}
