import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class BookmarkViewController: BaseViewController<BookmarkViewModel> {
    private let removeBookmark = PublishRelay<Int>()
    private let bookmarkTableView = UITableView().then {
        $0.rowHeight = 80
        $0.separatorStyle = .none
        $0.register(
            BookmarkTableViewCell.self,
            forCellReuseIdentifier: BookmarkTableViewCell.identifier
        )
        $0.showsVerticalScrollIndicator = false
    }
    private let emptyBookmarkView = EmptyBookmarkView().then {
        $0.isHidden = true
    }
    private let navigateToRecruitmentButton = JobisButton(style: .sub).then {
        $0.setText("모집의뢰서 보러 가기")
        $0.isHidden = true
    }

    public override func addView() {
        [
            bookmarkTableView
        ].forEach(self.view.addSubview(_:))

        [
            emptyBookmarkView,
            navigateToRecruitmentButton
        ].forEach(self.bookmarkTableView.addSubview(_:))
    }

    public override func setLayout() {
        bookmarkTableView.snp.makeConstraints {
            $0.topMargin.leading.trailing.bottom.equalToSuperview()
        }

        emptyBookmarkView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(80)
            $0.centerX.equalToSuperview()
        }

        navigateToRecruitmentButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyBookmarkView.snp.bottom).offset(24)
        }
    }

    public override func bind() {
        let input = BookmarkViewModel.Input(
            viewWillAppear: self.viewWillAppearPublisher,
            removeBookmark: removeBookmark
        )
        let ouput = viewModel.transform(input)

        ouput.bookmarkList
            .skip(1)
            .do(onNext: { list in
                [
                    self.emptyBookmarkView,
                    self.navigateToRecruitmentButton
                ].forEach {
                    $0.isHidden = !list.isEmpty
                }
            })
            .bind(to: bookmarkTableView.rx.items(
                cellIdentifier: BookmarkTableViewCell.identifier,
                cellType: BookmarkTableViewCell.self
            )) { _, item, cell in
                cell.adapt(model: item)
                cell.trashButtonDidTap = {
                    self.removeBookmark.accept(cell.bookmarkId)
                }
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        navigateToRecruitmentButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.tabBarController?.selectedIndex = 1
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setLargeTitle(title: "북마크")
    }
}
