import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public class SignupViewController: BaseViewController<SignupViewModel> {
    private let label = UILabel().then {
        $0.setJobisText("회원가입", font: .body, color: .black)
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
        self.view.backgroundColor = .GrayScale.gray10
    }
}
