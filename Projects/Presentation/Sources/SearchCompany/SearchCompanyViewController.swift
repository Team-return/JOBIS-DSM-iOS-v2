import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import ReactorKit

public final class SearchCompanyViewController: BaseReactorViewController<SearchCompanyReactor> {
    private let emptySearchView = ListEmptyView().then {
        $0.isHidden = true
        $0.setEmptyView(
            title: "검색어와 관련된 회사를 못찾았어요",
            subTitle: "제대로 입력했는지 다시 한번 확인해주세요"
        )
    }

    private let searchImageView = UIImageView().then {
        $0.image = .jobisIcon(.searchIcon)
    }
    private let searchTextField = UITextField().then {
        $0.placeholder = "검색어를 입력해주세요"
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 0))
        $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        $0.leftViewMode = .always
        $0.rightViewMode = .always
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 12
    }

    private let searchTableView = UITableView().then {
        $0.rowHeight = 72
        $0.separatorStyle = .none
        $0.register(
            CompanyTableViewCell.self,
            forCellReuseIdentifier: CompanyTableViewCell.identifier
        )
        $0.showsVerticalScrollIndicator = false
    }

    public override func addView() {
        [
            searchTextField,
            searchImageView,
            searchTableView
        ].forEach(self.view.addSubview(_:))
        [
            emptySearchView
        ].forEach(searchTableView.addSubview(_:))
    }

    public override func setLayout() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets)
            $0.trailing.leading.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }

        searchImageView.snp.makeConstraints {
            $0.centerY.equalTo(searchTextField)
            $0.left.equalTo(searchTextField.snp.left).inset(16)
        }

        searchTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(searchTextField.snp.bottom).offset(12)
        }

        emptySearchView.snp.makeConstraints {
            $0.centerY.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }

    public override func bindAction() {
        viewWillAppearPublisher.asObservable()
            .skip(1)
            .map { SearchCompanyReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchTableView.rx.willDisplayCell
            .filter { [weak self] event in
                guard let self = self else { return false }
                return event.indexPath.row == self.searchTableView.numberOfRows(inSection: event.indexPath.section) - 1
            }
            .map { _ in SearchCompanyReactor.Action.loadMoreCompanies }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchTableView.rx.itemSelected
            .compactMap { [weak self] indexPath -> Int? in
                guard let self = self else { return nil }
                return self.reactor.currentState.companyList[indexPath.row].companyID
            }
            .map { SearchCompanyReactor.Action.companyDidSelect($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.companyList }
            .skip(1)
            .do(onNext: { [weak self] list in
                self?.emptySearchView.isHidden = !list.isEmpty
            })
            .bind(to: searchTableView.rx.items(
                cellIdentifier: CompanyTableViewCell.identifier,
                cellType: CompanyTableViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.isEmptyViewHidden }
            .distinctUntilChanged()
            .bind(to: emptySearchView.rx.isHidden)
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        self.searchTextField.delegate = self
        viewWillAppearPublisher.asObservable()
            .bind { [weak self] in
                self?.hideTabbar()
                self?.navigationController?.navigationBar.prefersLargeTitles = false
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() { }
}

extension SearchCompanyViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let searchText = textField.text ?? ""
        reactor.action.onNext(.searchTextDidSubmit(searchText))
        self.view.endEditing(true)
        return true
    }
}
