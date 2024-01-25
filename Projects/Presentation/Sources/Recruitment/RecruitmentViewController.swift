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
        $0.showsVerticalScrollIndicator = false
    }
    private let navigateToFilterButton = UIButton().then {
        $0.setImage(.jobisIcon(.filterIcon), for: .normal)
    }
    private let navigateToSearchButton = UIButton().then {
        $0.setImage(.jobisIcon(.searchIcon), for: .normal)
    }

    public override func addView() {
        self.view.addSubview(recruitmentTableView)
    }

    public override func setLayout() {
        recruitmentTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public override func bind() {
        let input = RecruitmentViewModel.Input(
            viewAppear: self.viewWillAppearPublisher,
            bookMarkButtonDidTap: cellClick
        )
        let output = viewModel.transform(input)

        output.recruitmentList
            .bind(
                to: recruitmentTableView.rx.items(
                    cellIdentifier: RecruitmentTableViewCell.identifier,
                    cellType: RecruitmentTableViewCell.self
                )) { _, element, cell in
                    cell.adapt(model: element)
                    cell.bookmarkButtonDidTap = {
                        self.cellClick.accept(cell.recruitmentID)
                    }
                }
                .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        navigateToSearchButton.rx.tap
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: navigateToFilterButton),
            UIBarButtonItem(customView: navigateToSearchButton)
        ]
        setLargeTitle(title: "모집의뢰서")
    }
}
