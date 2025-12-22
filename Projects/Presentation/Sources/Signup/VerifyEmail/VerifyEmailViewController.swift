import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import ReactorKit

public final class VerifyEmailViewController: BaseReactorViewController<VerifyEmailReactor> {
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

    public override func addView() {
        [
            emailTextField,
            authCodeTextField,
            nextButton
        ].forEach { self.view.addSubview($0) }
    }

    public override func setLayout() {
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        authCodeTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bindAction() {
        emailTextField.textField.rx.text.orEmpty
            .map { VerifyEmailReactor.Action.updateEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        authCodeTextField.textField.rx.text.orEmpty
            .map { VerifyEmailReactor.Action.updateAuthCode($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        emailTextField.textFieldRightView.customButton.rx.tap
            .map { VerifyEmailReactor.Action.sendAuthCodeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .map { VerifyEmailReactor.Action.nextButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.isSuccessedToSendAuthCode }
            .distinctUntilChanged()
            .bind { [weak self] isSuccessedToSendAuthCode in
                if isSuccessedToSendAuthCode {
                    UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve) {
                        self?.authCodeTextField.startTimer()
                        self?.emailTextField.setDescription(
                            .success(description: "인증 메일이 발송되었어요.")
                        )
                        self?.emailTextField.textFieldRightView.setCustomButtonTitle(title: "재발송")
                    }
                }
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.emailErrorDescription }
            .distinctUntilChanged { (lhs: DescriptionType?, rhs: DescriptionType?) -> Bool in
                return (lhs?.description ?? "") == (rhs?.description ?? "")
            }
            .compactMap { $0 }
            .bind { [weak self] description in
                self?.emailTextField.setDescription(description)
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.authCodeErrorDescription }
            .distinctUntilChanged { (lhs: DescriptionType?, rhs: DescriptionType?) -> Bool in
                return (lhs?.description ?? "") == (rhs?.description ?? "")
            }
            .compactMap { $0 }
            .bind { [weak self] description in
                self?.authCodeTextField.setDescription(description)
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        emailTextField.textField.delegate = self
        authCodeTextField.textField.delegate = self

        authCodeTextField.textField.rx.text.orEmpty
            .observe(on: MainScheduler.asyncInstance)
            .limitWithOnlyInt(6) { [weak self] in
                self?.authCodeTextField.textField.resignFirstResponder()
                self?.reactor.action.onNext(.nextButtonDidTap)
            }
            .bind(to: authCodeTextField.textField.rx.text)
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setLargeTitle(title: "이메일을 입력해주세요")
    }
}

extension VerifyEmailViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField.textField {
            self.authCodeTextField.textField.becomeFirstResponder()
        } else if textField == authCodeTextField.textField {
            self.reactor.action.onNext(.nextButtonDidTap)
        }
        return true
    }
}
