import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class RecruitmentSearchViewController: BaseViewController<RecruitmentSearchViewModel> {
    private let searchButtonDidTap = PublishRelay<Void>()
    private let bookmarkButtonDidClicked = PublishRelay<Int>()
    private let searchBar = UISearchBar()
    private let emptySearchView = ListEmptyView().then {
        $0.isHidden = true
        $0.setEmptyView(
            title: "검색어와 관련 된 회사를 못찾았어요",
            subTitle: "제대로 입력했는지 다시 한번 확인해주세요"
        )
    }

    private let searchTableView = UITableView().then {
        $0.rowHeight = 72
        $0.separatorStyle = .none
        $0.register(
            RecruitmentTableViewCell.self,
            forCellReuseIdentifier: RecruitmentTableViewCell.identifier
        )
        $0.showsVerticalScrollIndicator = false
    }
    public override func addView() {
        [
            searchBar,
            searchTableView
        ].forEach(self.view.addSubview(_:))
        [
            emptySearchView
        ].forEach(searchTableView.addSubview(_:))
    }

    public override func setLayout() {
        searchBar.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaInsets)
        }
        searchTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom)
        }

        emptySearchView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(80)
            $0.centerX.equalToSuperview()
        }
    }

    public override func bind() {
        let input = RecruitmentSearchViewModel.Input(
            viewAppear: self.viewWillAppearPublisher,
            pageChange: searchTableView.rx.willDisplayCell
                .filter {
                    $0.indexPath.row == self.searchTableView.numberOfRows(inSection: $0.indexPath.section) - 1
                }.asObservable(),
            searchButtonDidTap: searchButtonDidTap,
            bookmarkButtonDidClicked: bookmarkButtonDidClicked,
            searchTableViewDidTap: searchTableView.rx.itemSelected
        )

        let output = viewModel.transform(input)

        output.recruitmentListInfo
            .skip(1)
            .do(onNext: {
                self.emptySearchView.isHidden = !$0.isEmpty
            })
            .bind(to: searchTableView.rx.items(
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
        searchBar.placeholder = "검색어를 입력해주세요"
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        self.emptySearchView.isHidden = false
    }

    public override func configureNavigation() { }
}

extension RecruitmentSearchViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let title = searchBar.text
        guard let text = title else { return }
        viewModel.searchText = text
        searchButtonDidTap.accept(())
    }
}
