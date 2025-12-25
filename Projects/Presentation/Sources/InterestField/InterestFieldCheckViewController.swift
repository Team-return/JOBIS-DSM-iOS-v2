import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class InterestFieldCheckViewController: BaseReactorViewController<InterestFieldCheckReactor> {
    private let interestView = InterestCheckView()
//    private let backButton = JobisButton(style: .main).then {
//        $0.setText("홈으로 가기")
//        $0.isEnabled = true
//    }

    public override func addView() {
        [
            interestView
//            backButton
        ].forEach(view.addSubview)
    }

    public override func setLayout() {
        interestView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.trailing.lessThanOrEqualToSuperview().inset(24)
        }
//        backButton.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.leading.trailing.equalToSuperview().inset(24)
//            $0.bottom.equalToSuperview().inset(24)
//        }
    }

    public override func configureNavigation() {
        setSmallTitle(title: "관심 분야 선택")
        self.navigationItem.largeTitleDisplayMode = .never
    }

    public override func bindAction() {
        viewWillAppearPublisher
            .map { InterestFieldCheckReactor.Action.fetchStudentInfo }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.studentName }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] name in
                self?.interestView.setStudentName(name)
            })
            .disposed(by: disposeBag)
    }
}
