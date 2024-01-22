import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import DesignSystem

final class HelpSectionView: BaseView {
    enum HelpSectionType: Int {
        case announcement
    }
    private let helpSectionView = SectionView(
        menuText: "도움말",
        items: [
            ("공지사항", .jobisIcon(.sound))
        ]
    )

    override func addView() {
        self.addSubview(helpSectionView)
    }

    override func setLayout() {
        helpSectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func getSelectedItem(type: HelpSectionType) -> Observable<IndexPath> {
        self.helpSectionView.getSelectedItem(index: type.rawValue)
    }
}
