import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class RecruitmentViewController: BaseViewController<RecruitmentViewModel> {
    private let bookmarkButtonDidClicked = PublishRelay<Int>()
    private let cellClick = PublishRelay<Void>()
    private let pageCount = PublishRelay<Int>()
    private let recruitmentTableView = UITableView().then {
        $0.register(
            RecruitmentTableViewCell.self,
            forCellReuseIdentifier: RecruitmentTableViewCell.identifier
        )
        $0.separatorStyle = .none
        $0.rowHeight = 96
        $0.showsVerticalScrollIndicator = false
    }
    private let filterButton = UIButton().then {
        $0.setImage(.jobisIcon(.filterIcon), for: .normal)
    }
    private let searchButton = UIButton().then {
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
            bookMarkButtonDidTap: bookmarkButtonDidClicked,
            pageChange: pageCount,
            cellClicked: cellClick
        )

        let output = viewModel.transform(input)

        output.recruitmentData
            .bind(
                to: recruitmentTableView.rx.items(
                    cellIdentifier: RecruitmentTableViewCell.identifier,
                    cellType: RecruitmentTableViewCell.self
                )) { _, element, cell in
                    cell.adapt(model: element)
                    cell.bookmarkButtonDidTap = {
                        self.bookmarkButtonDidClicked.accept(cell.recruitmentID)
                    }
                }
                .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        recruitmentTableView.delegate = self
        searchButton.rx.tap
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)

        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.showTabbar()
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: filterButton),
            UIBarButtonItem(customView: searchButton)
        ]
        setLargeTitle(title: "모집의뢰서")
    }
}

extension RecruitmentViewController: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section) - 1
        if indexPath.row == lastRowIndex {
            pageCount.accept(indexPath.row)
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.hideTabbar()
        cellClick.accept(())
    }
}
