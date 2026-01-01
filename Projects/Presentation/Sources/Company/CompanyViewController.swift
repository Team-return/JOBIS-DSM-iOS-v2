import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class CompanyViewController: BaseReactorViewController<CompanyReactor> {
    public var viewWillAppearWithTap: (() -> Void)?
    public var isTabNavigation: Bool = true
    private let companyTableView = UITableView().then {
        $0.register(
            CompanyTableViewCell.self,
            forCellReuseIdentifier: CompanyTableViewCell.identifier
        )
        $0.separatorStyle = .none
        $0.rowHeight = 104
        $0.showsVerticalScrollIndicator = false
    }
    private let searchButton = UIButton().then {
        $0.setImage(.jobisIcon(.searchIcon), for: .normal)
    }

    public override func addView() {
        [
            companyTableView
        ].forEach(view.addSubview(_:))
    }

    public override func setLayout() {
        companyTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public override func bindAction() {
        viewDidLoadPublisher
            .map { CompanyReactor.Action.fetchCompanyList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        companyTableView.rx.willDisplayCell
            .filter {
                $0.indexPath.row == self.companyTableView.numberOfRows(
                    inSection: $0.indexPath.section
                ) - 1
            }
            .map { _ in CompanyReactor.Action.loadMoreCompanies }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        companyTableView.rx.itemSelected
            .do(onNext: { _ in
                self.isTabNavigation = false
            })
            .compactMap { [weak self] indexPath -> Int? in
                guard let self = self,
                      indexPath.row < self.reactor.currentState.companyList.count else {
                    return nil
                }
                return self.reactor.currentState.companyList[indexPath.row].companyID
            }
            .map { CompanyReactor.Action.companyDidSelect($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchButton.rx.tap
            .map { CompanyReactor.Action.searchButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.companyList }
            .skip(1)
            .bind(onNext: { [weak self] _ in
                self?.companyTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        companyTableView.dataSource = self

        viewWillAppearPublisher.asObservable()
            .bind {
                self.hideTabbar()
                self.setSmallTitle(title: "기업 탐색")
                if self.isTabNavigation {
                    self.viewWillAppearWithTap?()
                }
                self.isTabNavigation = true
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: searchButton)
        ]
    }
}

extension CompanyViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor.currentState.companyList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CompanyTableViewCell.identifier,
            for: indexPath
        ) as? CompanyTableViewCell else {
            return UITableViewCell()
        }

        let company = reactor.currentState.companyList[indexPath.row]
        cell.adapt(model: company)

        return cell
    }
}
