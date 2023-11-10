import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public class SigninViewController: BaseViewController<SigninViewModel> {
    private let label = UILabel().then {
        $0.setJobisText("로그인", font: .body, color: .black)
    }
    public override func addView() {
        self.view.addSubview(label)
    }
    public override func layout() {
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    public override func attribute() {
    }
}
