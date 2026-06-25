import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import DesignSystem

final class BookmarkSectionView: BaseView {
    enum BookmarkSectionType: Int {
        case bookmark
    }
    private let bookmarkSectionView = SectionView(
        menuText: "북마크",
        items: [
            ("북마크", .jobisIcon(.bookmark))
        ]
    )

    override func addView() {
        self.addSubview(bookmarkSectionView)
    }

    override func setLayout() {
        bookmarkSectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func getSelectedItem(type: BookmarkSectionType) -> Observable<IndexPath> {
        self.bookmarkSectionView.getSelectedItem(index: type.rawValue)
    }
}
