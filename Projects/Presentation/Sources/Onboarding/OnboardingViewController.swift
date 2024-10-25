import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Lottie

public final class OnboardingViewController: BaseViewController<OnboardingViewModel> {
    private let animationView = JobisLottieView()
    private let teamReturnLogoImage = UIImageView().then {
        $0.image = .onboardingImage(.teamReturnLogo)
    }
    private let navigateButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.isHidden = true
    }
    private let navigateToSignupButton = JobisButton(style: .main).then {
        $0.setText("새 계정으로 시작하기")
    }
    private let navigateToSigninButton = UIButton(type: .system).then {
        $0.setJobisText("기존 계정으로 로그인하기", font: .subBody, color: .GrayScale.gray60)
        $0.setUnderline()
    }
    private var isOnLoading = false

    public override func addView() {
        [
            animationView,
            teamReturnLogoImage,
            navigateButtonStackView
        ].forEach(self.view.addSubview(_:))

        [
            navigateToSignupButton,
            navigateToSigninButton
        ].forEach(self.navigateButtonStackView.addArrangedSubview(_:))
    }

    public override func setLayout() {
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        teamReturnLogoImage.snp.makeConstraints {
            $0.bottomMargin.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(88)
            $0.height.equalTo(48)
        }

        navigateButtonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(4)
        }
    }

    public override func bind() {
        let input = OnboardingViewModel.Input(
            navigateToSigninDidTap: navigateToSigninButton.rx.tap.asSignal(),
            navigateToSignupDidTap: navigateToSignupButton.rx.tap.asSignal(),
            viewAppear: viewDidAppearPublisher
        )
        let output = viewModel.transform(input)

        output.animate.asObservable()
            .bind(onNext: { [weak self] in
                guard let self else { return }

                if !isOnLoading {
                    animationView.play()
                }
                isOnLoading = true
            }).disposed(by: disposeBag)

        output.showNavigationButton.asObservable()
            .bind(onNext: { [weak self] in
                guard let self, isOnLoading else { return }
                UIView.transition(
                    with: self.navigateButtonStackView,
                    duration: 0.5,
                    options: .transitionCrossDissolve,
                    animations: {
                        self.setNavigateButton()
                    }
                )
            }).disposed(by: disposeBag)

        output.serverStatus.asObservable()
            .subscribe(onNext: {_ in
                AlertBuilder(viewController: self)
                    .setTitle("현재 JOBIS 서버가 점검중이에요")
                    .setMessage("더욱 원활한 서비스 이용을 위해\n노력중이니 조금만 기다려주세요!")
                    .addActionConfirm("확인")
                    .setAlertType(.positive)
                    .show()
            }).disposed(by: disposeBag)
    }

    private func setNavigateButton() {
        teamReturnLogoImage.isHidden = true
        navigateButtonStackView.isHidden = false
    }
}
