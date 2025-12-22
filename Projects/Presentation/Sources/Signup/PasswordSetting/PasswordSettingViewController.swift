import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import ReactorKit

public final class PasswordSettingViewController: BaseReactorViewController<PasswordSettingReactor> {
    private let passwordTextField = JobisTextField().then {
        $0.setTextField(
            title: "비밀번호",
            placeholder: "계정의 비밀번호를 설정해주세요.",
            descriptionType: .info(description: "8 ~ 16자, 영문자, 숫자, 특수문자(!@#$%^&*) 포함"),
            textFieldType: .secure
        )
    }
    private let checkingPasswordTextField = JobisTextField().then {
        $0.setTextField(
            title: "비밀번호 확인",
            placeholder: "위 비밀번호를 한 번 더 입력해주세요.",
            textFieldType: .secure
        )
    }
    private let nextButton = JobisButton(style: .main).then {
        $0.setText("다음")
    }

    public override func addView() {
        [
            passwordTextField,
            checkingPasswordTextField,
            nextButton
        ].forEach { self.view.addSubview($0) }
    }

    public override func setLayout() {
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        checkingPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bindAction() {
        passwordTextField.textField.rx.text.orEmpty
            .map { PasswordSettingReactor.Action.updatePassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        checkingPasswordTextField.textField.rx.text.orEmpty
            .map { PasswordSettingReactor.Action.updateCheckingPassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .map { PasswordSettingReactor.Action.nextButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.passwordErrorDescription }
            .distinctUntilChanged { (lhs: DescriptionType?, rhs: DescriptionType?) -> Bool in
                return (lhs?.description ?? "") == (rhs?.description ?? "")
            }
            .compactMap { $0 }
            .bind { [weak self] description in
                self?.passwordTextField.setDescription(description)
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.checkingPasswordErrorDescription }
            .distinctUntilChanged { (lhs: DescriptionType?, rhs: DescriptionType?) -> Bool in
                return (lhs?.description ?? "") == (rhs?.description ?? "")
            }
            .compactMap { $0 }
            .bind { [weak self] description in
                self?.checkingPasswordTextField.setDescription(description)
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        passwordTextField.textField.delegate = self
        checkingPasswordTextField.textField.delegate = self
    }

    public override func configureNavigation() {
        setLargeTitle(title: "비밀번호를 설정해주세요")
    }
}

extension PasswordSettingViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField.textField {
            self.passwordTextField.textField.becomeFirstResponder()
        } else if textField == checkingPasswordTextField.textField {
            self.reactor.action.onNext(.nextButtonDidTap)
        }
        return true
    }
}
