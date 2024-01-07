import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem

public final class HomeViewController: BaseViewController<HomeViewModel> {
    // TODO: 언젠가 지울 것
    private let isWinterSeason = BehaviorRelay(value: true)
    private let cellClick = PublishRelay<Int>()

    private let navigateToAlarmButton = UIButton().then {
        $0.setImage(.jobisIcon(.bell).resize(size: 28), for: .normal)
    }
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let studentInfoView = StudentInfoView()
    private let employmentView = EmploymentView()
    private let careerMenuLabel = JobisMenuLabel(text: "정보 조회")
    private var findCompanysCard = CareerNavigationCard(style: .small(type: .findCompanys))
    private var findWinterRecruitmentsCard = CareerNavigationCard(style: .small(type: .findWinterRecruitments))
    private let applicationStatusMenuLabel = JobisMenuLabel(text: "지원 현황")
    private let applicationStatusTableView = UITableView().then {
        $0.register(
            ApplicationStatusTableViewCell.self,
            forCellReuseIdentifier: ApplicationStatusTableViewCell.identifier
        )
        $0.rowHeight = 72
        $0.separatorStyle = .none
        $0.estimatedSectionHeaderHeight = 64
        $0.sectionHeaderTopPadding = 0
        $0.setEmptyHeaderView()
    }
    private let careerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 12
    }

    private func setCardStyle(isWinterSeason: Bool) {
        if isWinterSeason {
            findCompanysCard = CareerNavigationCard(style: .small(type: .findCompanys))
            findWinterRecruitmentsCard = CareerNavigationCard(style: .small(type: .findWinterRecruitments))
            findWinterRecruitmentsCard.isHidden = false
        } else {
            findCompanysCard = CareerNavigationCard(style: .large)
            findWinterRecruitmentsCard.isHidden = true
        }
    }

    public override func addView() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        [
            findCompanysCard,
            findWinterRecruitmentsCard
        ].forEach(careerStackView.addArrangedSubview(_:))
        [
            studentInfoView,
            employmentView,
            careerMenuLabel,
            careerStackView,
            applicationStatusMenuLabel,
            applicationStatusTableView
        ].forEach(contentView.addSubview(_:))
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.top.width.equalToSuperview()
            $0.bottom.equalTo(applicationStatusTableView.snp.bottom)
        }
        studentInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
        }

        employmentView.snp.makeConstraints {
            $0.top.equalTo(studentInfoView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        careerMenuLabel.snp.makeConstraints {
            $0.top.equalTo(employmentView.snp.bottom).offset(24)
        }

        careerStackView.snp.makeConstraints {
            $0.top.equalTo(careerMenuLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(176)
        }

        applicationStatusMenuLabel.snp.makeConstraints {
            $0.top.equalTo(careerStackView.snp.bottom).offset(24)
        }

        applicationStatusTableView.snp.makeConstraints {
            $0.top.equalTo(applicationStatusMenuLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(applicationStatusTableView.contentSize.height + 4)
        }
    }

    public override func bind() {
        let input = HomeViewModel.Input(
            viewAppear: viewDidLoadPublisher,
            navigateToAlarmButtonDidTap: navigateToAlarmButton.rx.tap.asSignal()
        )

        let output = viewModel.transform(input)

        output.studentInfo
            .bind { [weak self] studentInfo in
                self?.studentInfoView.setStudentInfo(
                    profileImageUrl: studentInfo.profileImageUrl,
                    gcn: studentInfo.studentGcn,
                    name: studentInfo.studentName,
                    department: studentInfo.department.localizedString()
                )
            }
            .disposed(by: disposeBag)

        output.employmentPercentage
            .bind { [weak self] employmentPercentage in
                guard let self else { return }

                employmentView.setEmploymentPercentage(employmentPercentage)
            }
            .disposed(by: disposeBag)

        output.applicationList
            .do(onNext: { [weak self] applicationList in
                if applicationList.isEmpty {
                    self?.applicationStatusTableView.setEmptyHeaderView()
                    self?.applicationStatusTableView.estimatedSectionHeaderHeight = 64
                } else {
                    self?.applicationStatusTableView.estimatedSectionHeaderHeight = 0
                    self?.applicationStatusTableView.tableHeaderView = nil
                    self?.applicationStatusTableView.reloadData()
                }
            })
            .bind(
                to: applicationStatusTableView.rx.items(
                    cellIdentifier: ApplicationStatusTableViewCell.identifier,
                    cellType: ApplicationStatusTableViewCell.self
                )
            ) { _, element, cell in
                cell.setCell(element)
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        setCardStyle(isWinterSeason: isWinterSeason.value)

        findCompanysCard.rx.tap.subscribe(onNext: {
            print("findCompany!")
        })
        .disposed(by: disposeBag)

        findWinterRecruitmentsCard.rx.tap.subscribe(onNext: {
            print("findWinterRecruitment!!")
        })
        .disposed(by: disposeBag)

        navigateToAlarmButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.hideTabbar()
            })
            .disposed(by: disposeBag)

        applicationStatusTableView.rx.itemSelected
            .map { index -> Int? in
                guard let cell = self.applicationStatusTableView.cellForRow(at: index)
                        as? ApplicationStatusTableViewCell
                else { return nil }
                return cell.applicationID
            }
            .compactMap { $0 }
            .bind(to: cellClick)
            .disposed(by: disposeBag)

        cellClick.asObservable()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.navigationItem.rightBarButtonItem = .init(customView: navigateToAlarmButton)
    }
}

extension UITableView {
    func setEmptyHeaderView() {
        let headerView = EmptyApplicationView()
        self.tableHeaderView = headerView
    }
}
