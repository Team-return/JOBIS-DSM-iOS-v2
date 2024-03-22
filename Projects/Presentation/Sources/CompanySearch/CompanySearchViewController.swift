import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public class CompanySearchViewController: BaseViewController<CompanySearchViewModel> {
    private let companySearchTableViewCellDidTap = PublishRelay<Int>()
    private var companyId: Int?

    private let companySearchTableView = UITableView().then {
        $0.register(
            CompanySearchTableViewCell.self,
            forCellReuseIdentifier: CompanySearchTableViewCell.identifier
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
            companySearchTableView
        ].forEach(view.addSubview(_:))
    }

    public override func setLayout() {
        companySearchTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public override func bind() {
        let input = CompanySearchViewModel.Input(
            viewAppear: self.viewWillAppearPublisher,
            pageChange: companySearchTableView.rx.willDisplayCell
                .filter {
                    $0.indexPath.row == self.companySearchTableView.numberOfRows(inSection: $0.indexPath.section) - 1
                }
                .asObservable(),
            companySearchTableViewCellDidTap: companySearchTableViewCellDidTap
        )

        let output = viewModel.transform(input)

        output.companyList
            .skip(1)
            .bind(
                to: companySearchTableView.rx.items(
                    cellIdentifier: CompanySearchTableViewCell.identifier,
                    cellType: CompanySearchTableViewCell.self
                )) { _, element, cell in
                    cell.adapt(model: element)
                }
                .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        viewWillAppearPublisher
            .bind {
                self.hideTabbar()
            }
            .disposed(by: disposeBag)

        companySearchTableView.rx.modelSelected(CompanyEntity.self)
            .subscribe(onNext: { data in
                self.companySearchTableViewCellDidTap.accept(data.companyID)
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.setSmallTitle(title: "상세 보기")
        self.navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: searchButton)
        ]
    }
}
