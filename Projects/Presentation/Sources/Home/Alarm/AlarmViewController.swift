import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem

public final class AlarmViewController: BaseViewController<AlarmViewModel> {
    private let alarmTableView = UITableView().then {
        $0.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
    }

    public override func addView() {
        self.view.addSubview(alarmTableView)
    }

    public override func setLayout() {
        alarmTableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    public override func bind() {
        let input = AlarmViewModel.Input(
            viewAppear: viewDidAppearPublisher,
            readNotification:
                Observable.zip(
                    alarmTableView.rx.modelSelected(NotificationEntity.self),
                    alarmTableView.rx.itemSelected
                )
        )
        let output = viewModel.transform(input)

        output.notificationList.asObservable()
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
