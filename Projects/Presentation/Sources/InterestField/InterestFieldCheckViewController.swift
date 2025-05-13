import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class InterestFieldCheckViewController: BaseViewController<InterestFieldCheckViewModel> {
    private let interestView = InterestCheckView()

    public override func addView() {
        [
            interestView
        ].forEach(view.addSubview)
    }

    public override func setLayout() {
        interestView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(222)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func configureNavigation() {
        setSmallTitle(title: "관심사 설정")
        self.navigationItem.largeTitleDisplayMode = .never
    }
}
