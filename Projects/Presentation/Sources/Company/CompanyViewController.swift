import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class CompanyViewController: BaseViewController<CompanyViewModel> {
    private var viewWillAppearWithTap: (() -> Void)?
    private var isTabNavigation: Bool = true
    private let searchButtonDidTap = PublishRelay<Void>()
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

    public override func bind() {
        let input = CompanyViewModel.Input(
            viewAppear: self.viewDidLoadPublisher,
            pageChange: companyTableView.rx.willDisplayCell
                .filter {
                    $0.indexPath.row == self.companyTableView.numberOfRows(
                        inSection: $0.indexPath.section
                    ) - 1
                },
            companyTableViewCellDidTap: companyTableView.rx.modelSelected(CompanyEntity.self)
                .map { $0.companyID }
                .do(onNext: { _ in
                    self.isTabNavigation = false
                }),
            searchButtonDidTap: searchButtonDidTap
        )

        let output = viewModel.transform(input)

        output.companyList
            .skip(1)
            .bind(
                to: companyTableView.rx.items(
                    cellIdentifier: CompanyTableViewCell.identifier,
                    cellType: CompanyTableViewCell.self
                )) { _, element, cell in
                    cell.adapt(model: element)
                }
                .disposed(by: disposeBag)
    }

    public override func configureViewController() {
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

        searchButton.rx.tap
            .subscribe(onNext: { _ in
                self.searchButtonDidTap.accept(())
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: searchButton)
        ]
    }
}
