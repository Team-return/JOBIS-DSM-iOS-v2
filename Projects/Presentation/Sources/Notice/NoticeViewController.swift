import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class NoticeViewController: BaseReactorViewController<NoticeReactor> {
    private let noticeTableView = UITableView().then {
        $0.register(
            NoticeTableViewCell.self,
            forCellReuseIdentifier: NoticeTableViewCell.identifier
        )
        $0.separatorStyle = .none
        $0.rowHeight = 80
        $0.showsVerticalScrollIndicator = false
    }

    public override func addView() {
        view.addSubview(noticeTableView)
    }

    public override func setLayout() {
        noticeTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaInsets)
        }
    }

    public override func bindAction() {
        viewWillAppearPublisher
            .map { NoticeReactor.Action.viewDidAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        noticeTableView.rx.modelSelected(NoticeEntity.self)
            .map { NoticeReactor.Action.noticeDidSelect($0.companyId) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.noticeList }
            .bind(to: noticeTableView.rx.items(
                cellIdentifier: NoticeTableViewCell.identifier,
                cellType: NoticeTableViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        viewWillAppearPublisher
            .subscribe(onNext: { [weak self] in
                self?.hideTabbar()
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setSmallTitle(title: "공지사항")
        navigationItem.largeTitleDisplayMode = .never
    }
}
