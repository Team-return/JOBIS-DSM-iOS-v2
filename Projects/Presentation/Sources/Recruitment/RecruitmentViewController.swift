import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import SkeletonView

public final class RecruitmentViewController: BaseReactorViewController<RecruitmentReactor> {
    public var viewWillappearWithTap: (() -> Void)?
    public var isTabNavigation: Bool = true
    private let bookmarkButtonDidClicked = PublishRelay<Int>()
    private let pageCount = PublishRelay<Int>()
    private let listEmptyView = ListEmptyView().then {
        $0.setEmptyView(title: "아직 등록된 모집의뢰서가 없어요")
        $0.isHidden = true
    }
    private let recruitmentTableView = UITableView().then {
        $0.register(
            RecruitmentTableViewCell.self,
            forCellReuseIdentifier: RecruitmentTableViewCell.identifier
        )
        $0.separatorStyle = .none
        $0.rowHeight = 72
        $0.showsVerticalScrollIndicator = false
        $0.isSkeletonable = true
    }
    private let filterButton = UIButton().then {
        $0.setImage(.jobisIcon(.filterIcon), for: .normal)
    }
    private let searchButton = UIButton().then {
        $0.setImage(.jobisIcon(.searchIcon), for: .normal)
    }

    public override func addView() {
        self.view.addSubview(recruitmentTableView)
        recruitmentTableView.addSubview(listEmptyView)
    }

    public override func setLayout() {
        recruitmentTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        listEmptyView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(80)
        }
    }

    public override func bindAction() {
        viewDidLoadPublisher
            .map { RecruitmentReactor.Action.fetchRecruitmentList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        recruitmentTableView.rx.willDisplayCell
            .filter {
                return !self.reactor.currentState.isLoading &&
                    $0.indexPath.row == self.recruitmentTableView.numberOfRows(
                        inSection: $0.indexPath.section
                    ) - 1
            }
            .map { _ in RecruitmentReactor.Action.loadMoreRecruitments }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        bookmarkButtonDidClicked
            .map { RecruitmentReactor.Action.bookmarkButtonDidTap($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        recruitmentTableView.rx.itemSelected
            .do(onNext: { _ in
                self.isTabNavigation = false
            })
            .compactMap { [weak self] indexPath -> Int? in
                guard let self = self,
                      !self.reactor.currentState.isLoading,
                      indexPath.row < self.reactor.currentState.recruitmentList.count else {
                    return nil
                }
                return self.reactor.currentState.recruitmentList[indexPath.row].recruitID
            }
            .map { RecruitmentReactor.Action.recruitmentDidSelect($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchButton.rx.tap
            .map { RecruitmentReactor.Action.searchButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        filterButton.rx.tap
            .map { RecruitmentReactor.Action.filterButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { ($0.recruitmentList, $0.isLoading) }
            .skip(1)
            .bind(onNext: { [weak self] list, isLoading in
                guard let self = self else { return }
                self.listEmptyView.isHidden = isLoading || !list.isEmpty

                if isLoading {
                    self.recruitmentTableView.reloadData()
                    DispatchQueue.main.async {
                        self.recruitmentTableView.showAnimatedSkeleton(
                            usingColor: .systemGray5,
                            transition: .crossDissolve(0.25)
                        )
                    }
                } else {
                    self.recruitmentTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                }
            })
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        recruitmentTableView.dataSource = self

        viewWillAppearPublisher.asObservable()
            .bind {
                self.showTabbar()
                self.setLargeTitle(title: "모집의뢰서")
                if self.isTabNavigation {
                    self.viewWillappearWithTap?()
                }
                self.isTabNavigation = true
            }
            .disposed(by: disposeBag)

        viewWillDisappearPublisher.asObservable()
            .bind {
                self.setSmallTitle(title: "")
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

extension RecruitmentViewController: SkeletonTableViewDataSource {
    public func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return RecruitmentTableViewCell.identifier
    }

    public func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor.currentState.isLoading ? 8 : reactor.currentState.recruitmentList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecruitmentTableViewCell.identifier,
            for: indexPath
        ) as? RecruitmentTableViewCell else {
            return UITableViewCell()
        }

        if !reactor.currentState.isLoading {
            let recruitment = reactor.currentState.recruitmentList[indexPath.row]
            cell.adapt(model: recruitment)
            cell.bookmarkButtonDidTap = { [weak self] in
                self?.bookmarkButtonDidClicked.accept(recruitment.recruitID)
            }
        }

        return cell
    }
}
