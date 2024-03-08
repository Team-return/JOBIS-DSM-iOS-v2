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
        let input = NoticeViewModel.Input(cellClick: cellClick)
        _ = viewModel.transform(input)
    }

    public override func configureViewController() {
        noticeTableView.dataSource = self
        noticeTableView.delegate = self

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

extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = noticeTableView.dequeueReusableCell(withIdentifier: NoticeTableViewCell.identifier, for: indexPath)
        return cell
    }

    public func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        cellClick.accept(())
    }
}
