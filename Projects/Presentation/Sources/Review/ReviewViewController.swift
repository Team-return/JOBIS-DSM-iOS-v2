import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import ReactorKit

public final class ReviewViewController: BaseReactorViewController<ReviewReactor> {
    public var viewWillappearWithTap: (() -> Void)?
    public var isTabNavigation: Bool = true
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

    public override func bindAction() {
        viewDidLoadPublisher.asObservable()
            .map { ReviewReactor.Action.fetchReviewList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reviewTableView.rx.willDisplayCell
            .filter { [weak self] event in
                guard let self = self else { return false }
                return event.indexPath.row == self.reviewTableView.numberOfRows(
                    inSection: event.indexPath.section
                ) - 1
            }
            .map { _ in ReviewReactor.Action.loadMoreReviews }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reviewTableView.rx.modelSelected(ReviewEntity.self)
            .do(onNext: { [weak self] _ in
                self?.isTabNavigation = false
            })
            .map { ReviewReactor.Action.reviewDidSelect($0.reviewID) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchButton.rx.tap
            .map { ReviewReactor.Action.searchButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        filterButton.rx.tap
            .map { ReviewReactor.Action.filterButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.reviewList }
            .skip(1)
            .do(onNext: { [weak self] list in
                self?.listEmptyView.isHidden = !list.isEmpty
            })
            .bind(to: reviewTableView.rx.items(
                cellIdentifier: ReviewTableViewCell.identifier,
                cellType: ReviewTableViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        viewWillAppearPublisher.asObservable()
            .bind { [weak self] in
                guard let self = self else { return }
                self.showTabbar()
                self.setLargeTitle(title: "후기")
                if self.isTabNavigation {
                    self.viewWillappearWithTap?()
                }
                self.isTabNavigation = true
            }
            .disposed(by: disposeBag)

        viewWillDisappearPublisher.asObservable()
            .bind { [weak self] in
                self?.setSmallTitle(title: "")
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: searchButton),
            UIBarButtonItem(customView: filterButton)
        ]
    }
}
