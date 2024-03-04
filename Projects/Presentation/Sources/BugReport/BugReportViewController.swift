import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Kingfisher
import DesignSystem

public final class BugReportViewController: BaseViewController<BugReportViewModel> {

    private let bugReportMajorView = BugReportMajorView()
    private let bugReportTitleTextField = JobisTextField().then {
        $0.setTextField(title: "제보 제목", placeholder: "제목을 입력해주세요")
    }
    private let bugReportContentTextView = JobisTextView().then {
        $0.setTextField(title: "제보 내용", placeholder: "버그의 내용을 입력해주세요")
    }
    public override func addView() {
        [
            bugReportMajorView,
            bugReportTitleTextField,
            bugReportContentTextView
        ].forEach(self.view.addSubview(_:))
    }

    public override func setLayout() {
        bugReportMajorView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        bugReportTitleTextField.snp.makeConstraints {
            $0.top.equalTo(bugReportMajorView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        bugReportContentTextView.snp.makeConstraints {
            $0.top.equalTo(bugReportTitleTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }

    public override func configureViewController() {

    }

    public override func configureNavigation() {
        setLargeTitle(title: "버그 제보하기")
    }
}
