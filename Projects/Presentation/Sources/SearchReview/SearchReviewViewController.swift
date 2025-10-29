import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class SearchReviewViewController: BaseViewController<SearchReviewViewModel> {
    private let searchButtonDidTap = PublishRelay<String>()
    private let emptySearchView = ListEmptyView().then {
        $0.isHidden = true
        $0.setEmptyView(
            title: "검색어와 관련된 면접 후기를 못찾았어요",
            subTitle: "제대로 입력했는지 다시 한번 확인해주세요"
        )
    }

    private let searchImageView = UIImageView().then {
        $0.image = .jobisIcon(.searchIcon)
    }
    private let searchTextField = UITextField().then {
        $0.placeholder = "찾고 싶은 면접 후기를 입력해주세요"
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
            ReviewTableViewCell.self,
            forCellReuseIdentifier: ReviewTableViewCell.identifier
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

    public override func bind() {
        let input = SearchReviewViewModel.Input(
            viewAppear: self.viewWillAppearPublisher,
            pageChange: searchTableView.rx.willDisplayCell
                .filter {
                    $0.indexPath.row == self.searchTableView.numberOfRows(inSection: $0.indexPath.section) - 1
                }.asObservable(),
            searchButtonDidTap: searchButtonDidTap,
            searchTableViewDidTap: searchTableView.rx.itemSelected
        )

        let output = viewModel.transform(input)

        output.reviewListInfo
            .skip(1)
            .do(onNext: {
                self.emptySearchView.isHidden = !$0.isEmpty
            })
            .bind(to: searchTableView.rx.items(
                cellIdentifier: ReviewTableViewCell.identifier,
                cellType: ReviewTableViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
            }
            .disposed(by: disposeBag)

        output.emptyViewIsHidden.asObservable()
            .map {
                self.emptySearchView.isHidden = $0
            }
            .subscribe()
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        self.searchTextField.delegate = self
        viewWillAppearPublisher.asObservable()
            .bind {
                self.hideTabbar()
                self.navigationController?.navigationBar.prefersLargeTitles = false
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() { }
}

extension SearchReviewViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let title = textField.text
        viewModel.searchText = title
        searchButtonDidTap.accept(textField.text ?? "")
        self.view.endEditing(true)
        return true
    }
}
