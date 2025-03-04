import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import DesignSystem

final class AccountSectionView: BaseView {
    enum AccountSectionType: Int {
//        case interestField = 0
        case changePassword = 0
        case logout = 1
    }
    private let accountSectionView = SectionView(
        menuText: "계정",
        items: [
//            ("관심분야 선택", .jobisIcon(.code)),
            ("비밀번호 변경", .jobisIcon(.changePassword)),
            ("로그아웃", .jobisIcon(.logout))
        ]
    )

    override func addView() {
        self.addSubview(accountSectionView)
    }

    override func setLayout() {
        accountSectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func getSelectedItem(type: AccountSectionType) -> Observable<IndexPath> {
        self.accountSectionView.getSelectedItem(index: type.rawValue)
    }
}
