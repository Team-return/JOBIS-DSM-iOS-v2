//import UIKit
//import RxSwift
//import RxCocoa
//import SnapKit
//import Then
//import Core
//import Kingfisher
//import DesignSystem
//
//public final class BugReportListViewController: BaseViewController<BugReportListViewModel> {
//
//    private let bugReportMajorView = BugReportMajorView()
//    private let bugReportTitleTextField = JobisTextField().then {
//        $0.setTextField(title: "제보 제목", placeholder: "제목을 입력해주세요")
//    }
//    private let bugReportContentMenuLabel = JobisMenuLabel(text: "제보 내용")
//    private let bugReportListTableView = UITableView().then {
//        $0.register(
//            BugReportListTableViewCell.self,
//            forCellReuseIdentifier: BugReportListTableViewCell.identifier
//        )
//        $0.separatorStyle = .none
//        $0.rowHeight = 51
//        $0.showsVerticalScrollIndicator = false
//    }
//    public override func addView() {
//        [
//            bugReportMajorView,
//            bugReportTitleTextField,
//            bugReportContentMenuLabel,
//            bugReportListTableView
//        ].forEach(self.view.addSubview(_:))
//    }
//
//    public override func setLayout() {
//        bugReportMajorView.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide)
//            $0.leading.trailing.equalToSuperview()
//        }
//
//        bugReportTitleTextField.snp.makeConstraints {
//            $0.top.equalTo(bugReportMajorView.snp.bottom)
//            $0.leading.trailing.equalToSuperview()
//        }
//
//        bugReportContentMenuLabel.snp.makeConstraints {
//            $0.top.equalTo(bugReportTitleTextField.snp.bottom)
//            $0.leading.trailing.equalToSuperview()
//        }
//
//        bugReportListTableView.snp.makeConstraints {
//            $0.height.equalTo(150)
//            $0.top.equalTo(bugReportContentMenuLabel.snp.bottom)
//            $0.leading.trailing.equalToSuperview().inset(24)
//        }
//    }
//
//    public override func bind() {
//        let input = BugReportListViewModel.Input(
//            viewAppear: self.viewDidLoadPublisher,
//            majorViewDidTap: self.bugReportMajorView.majorViewDidTap
//        )
//
//        let output = viewModel.transform(input)
//
//        self.bugReportMajorView.majorLabel.text = output.majorType
//    }
//
//    public override func configureViewController() {
//        bugReportListTableView.dataSource = self
//        bugReportListTableView.delegate = self
//    }
//
//    public override func configureNavigation() {
//        setLargeTitle(title: "버그 제보하기")
//    }
//}
//
//extension BugReportListViewController: UITableViewDelegate, UITableViewDataSource {
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: BugReportListTableViewCell.identifier, for: indexPath)
//
//        return cell
//    }
//}
