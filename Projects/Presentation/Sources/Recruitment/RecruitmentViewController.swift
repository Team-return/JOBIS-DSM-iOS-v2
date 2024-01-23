import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class RecruitmentViewController: BaseViewController<RecruitmentViewModel> {
    private let cellClick = PublishRelay<Int>()

    private let recruitmentTableView = UITableView().then {
        $0.register(
            RecruitmentTableViewCell.self,
            forCellReuseIdentifier: RecruitmentTableViewCell.identifier
        )
        $0.separatorStyle = .none
        $0.rowHeight = 96
    }
    private let navigateToFilterButton = UIButton().then {
        $0.setImage(.jobisIcon(.filterIcon), for: .normal)
    }
    private let navigateToSearchButton = UIButton().then {
        $0.setImage(.jobisIcon(.searchIcon), for: .normal)
    }

    public override func addView() {
        self.view.addSubview(tableView)
    }

    public override func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public override func configureViewController() {
        tableView.dataSource = self
        tableView.delegate = self
        navigateToSearchButton.rx.tap
            .subscribe(onNext: { _ in
                print("Search!")
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: navigateToFilterButton),
            UIBarButtonItem(customView: navigateToSearchButton)
        ]
        setLargeTitle(title: "모집의뢰서")
    }

    public override func bind() {
        let input = RecruitmentViewModel.Input(
            viewAppear: self.viewAppear,
            bookMarkButtonDidTap: cellClick
        )
        let output = viewModel.transform(input)

        output.recruitmentList
            .bind(
                to: recruitmentTableView.rx.items(
                    cellIdentifier: RecruitmentTableViewCell.identifier,
                    cellType: RecruitmentTableViewCell.self
                )
            ) { _, element, cell in
                print(element.companyName, element.bookmarked)
                cell.setCell(element)
                cell.bookmarkButton.rx.tap.asObservable()
                    .subscribe(onNext: {
                        print("Clicked!:", $0)
                        //                        print("CellID:", cell.recruitmentID)
                        self.cellClick.accept(cell.recruitmentID ?? 0)
                    })
                    .disposed(by: self.disposeBag)
                //                self.cellClick.accept(cell.recruitmentID ?? 0)
            }
            .disposed(by: disposeBag)
    }
}
