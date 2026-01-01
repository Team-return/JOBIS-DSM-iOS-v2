import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import ReactorKit

public final class WinterInternViewController: BaseReactorViewController<WinterInternReactor> {
    public var viewWillappearWithTap: (() -> Void)?
    public var isTabNavigation: Bool = true
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
        viewWillAppearPublisher.asObservable()
            .map { WinterInternReactor.Action.fetchRecruitmentList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        recruitmentTableView.rx.willDisplayCell
            .filter { [weak self] event in
                guard let self = self else { return false }
                return event.indexPath.row == self.recruitmentTableView.numberOfRows(
                    inSection: event.indexPath.section
                ) - 1
            }
            .map { _ in WinterInternReactor.Action.loadMoreRecruitments }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        recruitmentTableView.rx.modelSelected(RecruitmentEntity.self)
            .do(onNext: { [weak self] _ in
                self?.isTabNavigation = false
            })
            .map { WinterInternReactor.Action.recruitmentDidSelect($0.recruitID) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchButton.rx.tap
            .map { WinterInternReactor.Action.searchButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        filterButton.rx.tap
            .map { WinterInternReactor.Action.filterButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.recruitmentList }
            .skip(1)
            .do(onNext: { [weak self] list in
                self?.listEmptyView.isHidden = !list.isEmpty
            })
            .bind(to: recruitmentTableView.rx.items(
                cellIdentifier: RecruitmentTableViewCell.identifier,
                cellType: RecruitmentTableViewCell.self
            )) { [weak self] _, element, cell in
                cell.adapt(model: element)
                cell.bookmarkButtonDidTap = { [weak self] in
                    guard let id = cell.model?.recruitID else { return }
                    self?.reactor.action.onNext(.bookmarkButtonDidTap(id))
                }
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        viewWillAppearPublisher.asObservable()
            .bind { [weak self] in
                guard let self = self else { return }
                self.hideTabbar()
                if self.isTabNavigation {
                    self.viewWillappearWithTap?()
                }
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.setSmallTitle(title: "체험형 현장실습")
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: searchButton),
            UIBarButtonItem(customView: filterButton)
        ]
    }
}
