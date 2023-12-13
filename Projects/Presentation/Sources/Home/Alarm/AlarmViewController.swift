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
        $0.register(AlarmCell.self, forCellReuseIdentifier: AlarmCell.identifier)
        $0.separatorStyle = .none
        $0.isScrollEnabled = true
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
    }

    public override func viewWillDisappear(_ animated: Bool) {
        showTabbar()
    }

    public override func attribute() {
        alarmTableView.dataSource = self
        alarmTableView.delegate = self

        setSmallTitle(title: "알림")
    }

    public override func addView() {
        self.view.addSubview(alarmTableView)
    }

    public override func layout() {
        alarmTableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AlarmCell.identifier,
            for: indexPath
        ) as? AlarmCell else { return UITableViewCell() }

        cell.setCell()
        cell.layoutIfNeeded()

        return cell
    }
}