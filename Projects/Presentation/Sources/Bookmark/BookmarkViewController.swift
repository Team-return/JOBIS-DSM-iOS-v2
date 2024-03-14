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
    private let emptyBookmarkView = ListEmptyView().then {
        $0.isHidden = true
        $0.setEmptyView(
            title: "현재 등록해 둔 북마크가 없어요",
            subTitle: "현재 북마크가 되어있는 모집의뢰서가 없어요.\n모집의뢰서를 보고 맘에든다면\n우측 하단의 북마크 버튼을 눌러주세요!"
        )
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
            removeBookmark: removeBookmark,
            bookmarkListDidTap: bookmarkTableView.rx.itemSelected.asObservable()
                .map {
                    guard let cell = self.bookmarkTableView.cellForRow(at: $0) as? BookmarkTableViewCell
                    else { return 0 }
                    return cell.model?.recruitmentID ?? 0
                }
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
                    self.removeBookmark.accept(cell.model?.recruitmentID ?? 0)
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

        viewWillAppearPublisher.asObservable()
            .bind {
                self.showTabbar()
                self.setLargeTitle(title: "북마크")
            }
            .disposed(by: disposeBag)

        viewWillDisappearPublisher.asObservable()
            .bind {
                self.setSmallTitle(title: "")
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() { }
}
