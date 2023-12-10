import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Lottie

public final class OnboardingViewController: BaseViewController<OnboardingViewModel> {
    private var isOnLoading = false

    private let animationView = LottieAnimationView(name: "OnboardingLottie", bundle: .module)

    private let teamReturnLogoImage = UIImageView().then {
        $0.image = PresentationAsset.teamReturnLogo.image.resize(.init(width: 88, height: 48))
    }

    private let jobisLogoImage = UIImageView().then {
        $0.image = PresentationAsset.jobisLogo.image.resize(.init(width: 205, height: 48))
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

    public override func addView() {
        [
            animationView,
            teamReturnLogoImage,
            jobisLogoImage,
            navigateButtonStackView
        ].forEach { self.view.addSubview($0)}

        [
            navigateToSignupButton,
            navigateToSigninButton
        ].forEach { self.navigateButtonStackView.addArrangedSubview($0) }
    }

    public override func layout() {
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        jobisLogoImage.snp.makeConstraints {
            $0.centerY.equalTo(animationView)
            $0.centerX.equalToSuperview()
        }

        teamReturnLogoImage.snp.makeConstraints {
            $0.bottomMargin.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-12)
            $0.centerX.equalToSuperview()
        }

        navigateButtonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(4)
        }
    }

    private func setNavigateButton() {
        teamReturnLogoImage.isHidden = true
        navigateButtonStackView.isHidden = false
    }

    public override func bind() {
        let input = OnboardingViewModel.Input(
            navigateToSigninDidTap: navigateToSigninButton.rx.tap.asSignal(),
            navigateToSignupDidTap: navigateToSignupButton.rx.tap.asSignal(),
            viewAppear: viewAppear
        )
        let output = viewModel.transform(input)
        output.animation.asObservable()
            .bind(onNext: { [weak self] in
                guard let self else { return }

                if !isOnLoading {
                    animationView.play()
                    UIView.transition(
                        with: navigateButtonStackView,
                        duration: 0.5,
                        options: .transitionCrossDissolve,
                        animations: {
                            self.setNavigateButton()
                        }
                    )
                }
                isOnLoading = true
            }).disposed(by: disposeBag)
    }

    public override func attribute() {
    }
}
