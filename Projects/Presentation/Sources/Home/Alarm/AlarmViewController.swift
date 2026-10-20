import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem
import ReactorKit

public final class AlarmViewController: BaseReactorViewController<AlarmReactor> {
    private let alarmTableView = UITableView().then {
        $0.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
    }
    private let filterSegment = UISegmentedControl(items: ["전체", "안읽음", "읽음"]).then {
        $0.selectedSegmentIndex = 0
    }

    public override func addView() {
        self.view.addSubview(filterSegment)
        self.view.addSubview(alarmTableView)
    }

    public override func setLayout() {
        filterSegment.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(32)
        }
        alarmTableView.snp.makeConstraints {
            $0.top.equalTo(filterSegment.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    public override func bindAction() {
        viewDidLoadPublisher.asObservable()
            .map { AlarmReactor.Action.fetchNotificationList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        Observable.zip(
            alarmTableView.rx.modelSelected(NotificationEntity.self),
            alarmTableView.rx.itemSelected
        )
        .map { AlarmReactor.Action.readNotification($0.0, $0.1.row) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)

        filterSegment.rx.selectedSegmentIndex
            .skip(1)
            .map { index -> AlarmReactor.Action in
                let filter: NotificationFilter
                switch index {
                case 1: filter = .unread
                case 2: filter = .read
                default: filter = .all
                }
                return .filterChanged(filter)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.filteredList }
            .bind(to: alarmTableView.rx.items(
                cellIdentifier: AlarmTableViewCell.identifier,
                cellType: AlarmTableViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: {
                self.hideTabbar()
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setSmallTitle(title: "알림")
    }
}
