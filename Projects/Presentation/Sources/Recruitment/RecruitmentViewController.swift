import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class RecruitmentViewController: BaseViewController<RecruitmentViewModel> {
    private let tableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(RecruitmentTableViewCell.self, forCellReuseIdentifier: RecruitmentTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 96
    }
    private let uiBarFilterButton = UIButton().then {
        $0.setImage(.jobisIcon(.filterIcon), for: .normal)
    }
    private let uiBarSearchButton = UIButton().then {
        $0.setImage(.jobisIcon(.searchIcon), for: .normal)
    }

    public override func attribute() {
        tableView.dataSource = self
        tableView.delegate = self

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: uiBarFilterButton),
            UIBarButtonItem(customView: uiBarSearchButton)
        ]
        setLargeTitle(title: "모집의뢰서")
        uiBarSearchButton.rx.tap
            .subscribe(onNext: { _ in
                print("hello")
            })
            .disposed(by: disposeBag)
    }

    public override func addView() {
        view.addSubview(tableView)
    }

    public override func layout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
extension RecruitmentViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecruitmentTableViewCell.identifier,
            for: indexPath
        ) as? RecruitmentTableViewCell else { return UITableViewCell() }

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.GrayScale.gray20
            // 다른 동작 수행 가능
            // 예: 특정 셀을 선택했을 때의 동작 처리

            // 지연 작업을 통해 일정 시간 후에 원래 색으로 돌아가도록 함
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.animate(withDuration: 0.1) {
                    cell.contentView.backgroundColor = UIColor.GrayScale.gray10
                }
            }
        }

        tableView.deselectRow(at: indexPath, animated: false)
    }
}
