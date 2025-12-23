import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import ReactorKit

public final class BookmarkViewController: BaseReactorViewController<BookmarkReactor> {
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

    public override func bindAction() {
        viewWillAppearPublisher.asObservable()
            .map { BookmarkReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        bookmarkTableView.rx.itemSelected
            .map { [weak self] indexPath in
                guard let cell = self?.bookmarkTableView.cellForRow(at: indexPath) as? BookmarkTableViewCell,
                      let id = cell.model?.recruitmentID else { return 0 }
                return id
            }
            .map { BookmarkReactor.Action.bookmarkItemDidTap($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.bookmarkList }
            .distinctUntilChanged { $0.count == $1.count }
            .do(onNext: { [weak self] list in
                [
                    self?.emptyBookmarkView,
                    self?.navigateToRecruitmentButton
                ].forEach {
                    $0?.isHidden = !list.isEmpty
                }
            })
            .bind(to: bookmarkTableView.rx.items(
                cellIdentifier: BookmarkTableViewCell.identifier,
                cellType: BookmarkTableViewCell.self
            )) { [weak self] _, item, cell in
                cell.adapt(model: item)
                cell.trashButtonDidTap = {
                    self?.reactor.action.onNext(.removeBookmark(cell.model?.recruitmentID ?? 0))
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
            .bind { [weak self] in
                self?.showTabbar()
                self?.setLargeTitle(title: "북마크")
            }
            .disposed(by: disposeBag)

        viewWillDisappearPublisher.asObservable()
            .bind { [weak self] in
                self?.setSmallTitle(title: "")
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() { }
}
