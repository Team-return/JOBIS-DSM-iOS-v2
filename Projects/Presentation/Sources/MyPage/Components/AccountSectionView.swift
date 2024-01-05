import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import DesignSystem

final class AccountSectionView: UIView {
    enum AccountSectionType: Int {
        case interestField = 0
        case changePassword = 1
        case logout = 2
        case withDraw = 3
    }
    private let accountSectionView = SectionView(menuText: "계정").then {
        $0.setSection(items: [
            ("관심분야 선택", .jobisIcon(.code)),
            ("비밀번호 변경", .jobisIcon(.changePassword)),
            ("로그아웃", .jobisIcon(.logout)),
            ("회원 탈퇴", .jobisIcon(.withdrawal))
        ])
    }

    override func layoutSubviews() {
        self.addSubview(accountSectionView)

        accountSectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func getSelectedItem(type: AccountSectionType) -> Observable<IndexPath> {
        self.accountSectionView.getSelectedItem(index: type.rawValue)
    }
}
