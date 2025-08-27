import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class ReviewViewController: BaseViewController<ReviewViewModel> {
    private let pageCount = PublishRelay<Int>()
    private let listEmptyView = ListEmptyView().then {
        $0.setEmptyView(title: "아직 등록된 후기가 없어요")
        $0.isHidden = true
    }
    private let reviewTableView = UITableView().then {
        $0.register(
            ReviewTableViewCell.self,
            forCellReuseIdentifier: ReviewTableViewCell.identifier
        )
        $0.separatorStyle = .none
        $0.rowHeight = 72
        $0.showsVerticalScrollIndicator = false
    }
    private let filterButton = UIButton().then {
        $0.setImage(.jobisIcon(.filterIcon), for: .normal)
    }
    private let searchButton = UIButton().then {
        $0.setImage(.jobisIcon(.searchIcon), for: .normal)
    }

    public override func bind() {
        let input = ReviewViewModel.Input(
            viewAppear: self.viewDidLoadPublisher,
            pageChange: reviewTableView.rx.willDisplayCell
                .filter {
                    $0.indexPath.row == self.reviewTableView.numberOfRows(
                        inSection: $0.indexPath.section
                    ) - 1
                }
        )

        let output = viewModel.transform(input)

        output.reviewData
            .skip(1)
            .do(onNext: {
                self.listEmptyView.isHidden = !$0.isEmpty
            })
            .bind(
                to: reviewTableView.rx.items(
                    cellIdentifier: ReviewTableViewCell.identifier,
                    cellType: ReviewTableViewCell.self
                )) { _, element, cell in
                    cell.adapt(model: element)
                }
                .disposed(by: disposeBag)
    }

    public override func addView() {
        self.view.addSubview(reviewTableView)
        reviewTableView.addSubview(listEmptyView)
    }

    public override func setLayout() {
        reviewTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        listEmptyView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(80)
        }
    }

    public override func configureNavigation() {
        self.setLargeTitle(title: "후기")

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: searchButton),
            UIBarButtonItem(customView: filterButton)
        ]
    }
}
