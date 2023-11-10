import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public class SigninViewController: BaseViewController<SigninViewModel> {
    private let titleLabel = UILabel().then {
        $0.setJobisText("JOBIS에 로그인하기", font: .pageTitle, color: .GrayScale.gray90, range: "JOBIS")
    }
    private let titleLineView = UIView().then {
        $0.backgroundColor = .GrayScale.gray90
    }
    private let titleImageView = UIImageView().then {
        $0.image = .jobisIcon(.door)
    }
    public override func addView() {
        [
            titleLabel,
            titleLineView,
            titleImageView
        ].forEach { self.view.addSubview($0) }
    }
    public override func layout() {
        titleLabel.snp.makeConstraints {
            $0.topMargin.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(24)
        }
        titleLineView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(12)
            $0.trailing.equalTo(titleImageView.snp.leading).offset(-12)
            $0.height.equalTo(1)
        }
        titleImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.width.height.equalTo(32)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    public override func attribute() {
    }
}
