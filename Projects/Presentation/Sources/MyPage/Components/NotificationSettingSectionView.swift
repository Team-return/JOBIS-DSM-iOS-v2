import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import DesignSystem

final class NotificationSettingSectionView: BaseView {
    enum NotificationSectionType: Int {
        case notificationSetting
    }
    private let notificationSettingSectionView = SectionView(
        menuText: "알림",
        items: [
            ("알림 설정", .jobisIcon(.bellOnPrimary))
        ]
    )

    override func addView() {
        self.addSubview(notificationSettingSectionView)
    }

    override func setLayout() {
        notificationSettingSectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func getSelectedItem(type: NotificationSectionType) -> Observable<IndexPath> {
        self.notificationSettingSectionView.getSelectedItem(index: type.rawValue)
    }
}
