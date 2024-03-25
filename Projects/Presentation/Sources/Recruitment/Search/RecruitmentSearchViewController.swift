import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class RecruitmentSearchViewController: BaseViewController<RecruitmentSearchViewModel> {
    private let searchButtonDidTap = PublishRelay<String>()
    private let bookmarkButtonDidClicked = PublishRelay<Int>()
    private let emptySearchView = ListEmptyView().then {
        $0.isHidden = true
        $0.setEmptyView(
            title: "검색어와 관련 된 회사를 못찾았어요",
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
            RecruitmentTableViewCell.self,
            forCellReuseIdentifier: RecruitmentTableViewCell.identifier
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

        output.emptyViewIsHidden.asObservable()
            .map {
                self.emptySearchView.isHidden = $0
            }
            .subscribe()
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        self.searchTextField.delegate = self
    }

    public override func configureNavigation() { }
}

extension RecruitmentSearchViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let title = textField.text
        viewModel.searchText = title
        searchButtonDidTap.accept(textField.text ?? "")
        self.view.endEditing(true)
        return true
    }
}
