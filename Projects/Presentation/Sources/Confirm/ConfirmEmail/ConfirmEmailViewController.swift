import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class ConfirmEmailViewController: BaseReactorViewController<ConfirmEmailReactor> {
    private let titleLabel = UILabel().then {
        $0.setJobisText(
            "비밀번호 변경을 위해\n이메일을 인증해주세요",
            font: .pageTitle,
            color: .GrayScale.gray90
        )
        $0.numberOfLines = 2
    }
    private let emailTextField = JobisTextField().then {
        $0.textField.keyboardType = .emailAddress
        $0.setTextField(
            title: "이메일",
            placeholder: "example",
            textFieldType: .emailWithbutton(buttonTitle: "인증하기")
        )
    }
    private let authCodeTextField = JobisTextField().then {
        $0.textField.keyboardType = .numberPad
        $0.setTextField(title: "인증코드", placeholder: "이메일로 온 코드를 입력해주세요")
    }
    private let nextButton = JobisButton(style: .main).then {
        $0.setText("다음")
    }
    let nextPublishRelay = PublishRelay<Void>()

    func nextButtonAction() {
        self.nextPublishRelay.accept(())
    }

    public override func addView() {
        [
            titleLabel,
            emailTextField,
            authCodeTextField,
            nextButton
        ].forEach(view.addSubview(_:))
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        emailTextField.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        authCodeTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bindAction() {
        emailTextField.textField.rx.text.orEmpty
            .map { ConfirmEmailReactor.Action.updateEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        authCodeTextField.textField.rx.text.orEmpty
            .map { ConfirmEmailReactor.Action.updateAuthCode($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        emailTextField.textFieldRightView.customButton.rx.tap
            .map { ConfirmEmailReactor.Action.sendAuthCodeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        nextPublishRelay
            .map { ConfirmEmailReactor.Action.nextButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state
            .map { $0.isSendAuthCodeSuccess }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(onNext: { [weak self] _ in
                UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve) {
                    self?.authCodeTextField.startTimer()
                    self?.emailTextField.setDescription(
                        .success(description: "인증 메일이 발송되었어요.")
                    )
                    self?.emailTextField.textFieldRightView.setCustomButtonTitle(title: "재발송")
                }
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.emailError }
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .bind(onNext: { [weak self] error in
                self?.emailTextField.setDescription(.error(description: error))
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.authCodeError }
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .bind(onNext: { [weak self] error in
                self?.authCodeTextField.setDescription(.error(description: error))
            })
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        authCodeTextField.textField.rx.text.orEmpty
            .observe(on: MainScheduler.asyncInstance)
            .limitWithOnlyInt(6) { [weak self] in
                self?.authCodeTextField.textField.resignFirstResponder()
                self?.nextButtonAction()
            }
            .bind(to: authCodeTextField.textField.rx.text )
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.nextButtonAction()
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}
