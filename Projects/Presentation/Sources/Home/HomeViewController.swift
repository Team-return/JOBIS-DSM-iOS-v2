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

    private let navigateToAlarmButton = UIBarButtonItem(
        image: .jobisIcon(.bell).resize(.init(width: 28, height: 28)),
        style: .plain,
        target: HomeViewController.self,
        action: nil
    )
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
        $0.register(ApplicationStatusCell.self, forCellReuseIdentifier: ApplicationStatusCell.identifier)
        $0.rowHeight = 72
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
    }
    private let emptyApplicationCell = EmptyApplicationCell()
    private let applicationStatusCells: [ApplicationEntity] = (0..<10).map { _ in
            .init(
                applicationID: Int.random(in: 0...100),
                company: "홍승재타이어(주)",
                attachments: [],
                applicationStatus: .requested
            )
    }

    private func setCardStyle(isWinterSeason: Bool) {
        if isWinterSeason {
            findCompanysCard = CareerNavigationCard(style: .small(type: .findCompanys))
            findWinterRecruitmentsCard = CareerNavigationCard(style: .small(type: .findWinterRecruitments))
        } else {
            findCompanysCard = CareerNavigationCard(style: .large)
        }
    }

    public override func attribute() {
        applicationStatusTableView.delegate = self
        applicationStatusTableView.dataSource = self

        setCardStyle(isWinterSeason: isWinterSeason.value)
        self.navigationItem.rightBarButtonItem = navigateToAlarmButton
        findCompanysCard.rx.tap.subscribe(onNext: {
            print("findCompany!")
        })
        .disposed(by: disposeBag)
        findWinterRecruitmentsCard.rx.tap.subscribe(onNext: {
            print("findWinterRecruitment!!")
        })
        .disposed(by: disposeBag)
    }

    public override func bind() {
        let input = HomeViewModel.Input(
            viewAppear: viewAppear,
            navigateToAlarmButtonDidTap: navigateToAlarmButton.rx.tap.asSignal()
        )

        let output = viewModel.transform(input)
        output.studentInfo
            .bind { [weak self] studentInfo in
                guard let self else { return }

                studentInfoView.setStudentInfo(
                    profileImageUrl: studentInfo.profileImageUrl,
                    gcn: studentInfo.studentGcn,
                    name: studentInfo.studentName,
                    department: studentInfo.department.localizedString()
                )
            }
            .disposed(by: disposeBag)
    }

    public override func addView() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        [
            studentInfoView,
            employmentView,
            careerMenuLabel,
            findCompanysCard,
            findWinterRecruitmentsCard,
            applicationStatusMenuLabel,
            applicationStatusTableView,
            emptyApplicationCell
        ].forEach(contentView.addSubview(_:))
    }

    public override func layout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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

        findCompanysCard.snp.makeConstraints {
            $0.top.equalTo(careerMenuLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(24)
            if isWinterSeason.value {
                $0.trailing.equalTo(view.snp.centerX).offset(-6)
            } else {
                $0.trailing.equalToSuperview().inset(24)
            }
        }

        if isWinterSeason.value {
            findWinterRecruitmentsCard.snp.makeConstraints {
                $0.top.equalTo(careerMenuLabel.snp.bottom)
                $0.leading.equalTo(view.snp.centerX).offset(6)
                $0.trailing.equalToSuperview().inset(24)
            }
        }

        applicationStatusMenuLabel.snp.makeConstraints {
            $0.top.equalTo(findCompanysCard.snp.bottom).offset(24)
        }

        if applicationStatusCells.isEmpty {
            emptyApplicationCell.snp.makeConstraints {
                $0.top.equalTo(applicationStatusMenuLabel.snp.bottom)
                $0.leading.trailing.equalToSuperview()
            }
        } else {
            applicationStatusTableView.snp.makeConstraints {
                $0.top.equalTo(applicationStatusMenuLabel.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.greaterThanOrEqualTo(applicationStatusTableView.contentSize.height + 4)
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applicationStatusCells.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let applicationStatusCell = tableView.dequeueReusableCell(
            withIdentifier: ApplicationStatusCell.identifier,
            for: indexPath
        ) as? ApplicationStatusCell else { return UITableViewCell() }

        applicationStatusCell.setCell(applicationStatusCells[indexPath.row])

        return applicationStatusCell
    }
}
