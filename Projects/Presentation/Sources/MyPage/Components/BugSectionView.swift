import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import DesignSystem

final class BugSectionView: BaseView {
    enum BugSectionType: Int {
        case reportBug
        case bugList
    }
    private let bugSectionView = SectionView(menuText: "버그제보").then {
        $0.setSection(items: [
            ("버그 제보하기", .jobisIcon(.bugReport)),
            ("버그 제보함", .jobisIcon(.bugBox))
        ])
    }

    override func addView() {
        self.addSubview(bugSectionView)
    }

    override func setLayout() {
        bugSectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func getSelectedItem(type: BugSectionType) -> Observable<IndexPath> {
        self.bugSectionView.getSelectedItem(index: type.rawValue)
    }
}
