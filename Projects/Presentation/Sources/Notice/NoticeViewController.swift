import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class NoticeViewController: BaseViewController<NoticeViewModel> {
    private let cellClick = PublishRelay<Void>()
    private let noticeTableViewCellDidTap = PublishRelay<Int>()
    private var noticeId: Int = 0

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

    public override func bind() {
        let input = NoticeViewModel.Input(
            viewAppear: self.viewWillAppearPublisher,
            noticeTableViewCellDidTap: noticeTableViewCellDidTap
        )

        let output = viewModel.transform(input)

        output.noticeListInfo.asObservable()
            .bind(
                to: noticeTableView.rx.items(
                    cellIdentifier: NoticeTableViewCell.identifier,
                    cellType: NoticeTableViewCell.self
                )) { _, element, cell in
                    cell.adapt(model: element)
                    self.noticeId = element.companyId
                }
                .disposed(by: disposeBag)

        noticeTableView.rx.modelSelected(NoticeEntity.self)
            .subscribe(onNext: { data in
                self.noticeTableViewCellDidTap.accept(data.companyId)
            })
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: {
                self.hideTabbar()
            })
    }

    public override func configureNavigation() {
        self.setSmallTitle(title: "공지사항")
        self.navigationItem.largeTitleDisplayMode = .never
    }
}
