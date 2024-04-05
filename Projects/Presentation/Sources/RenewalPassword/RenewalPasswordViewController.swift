import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class RenewalPasswordViewController: BaseViewController<RenewalPasswordViewModel> {
    public var email: String?
    private let titleLabel = UILabel().then {
        $0.setJobisText(
            "새로 사용할\n비밀번호를 입력해주세요",
            font: .pageTitle,
            color: .GrayScale.gray90
        )
        $0.numberOfLines = 2
    }
    private let newPasswordTextField = JobisTextField().then {
        $0.setTextField(
            title: "비밀번호",
            placeholder: "계정의 비밀번호를 설정해주세요.",
            descriptionType: .info(description: "8 ~ 16자, 영문자, 숫자, 특수문자(!@#$%^&*) 포함"),
            textFieldType: .secure
        )
    }
    private let checkNewPasswordTextField = JobisTextField().then {
        $0.setTextField(
            title: "비밀번호 확인",
            placeholder: "위 비밀번호를 한 번 더 입력해주세요.",
            textFieldType: .secure
        )
    }
    private let changePasswordButtonDidTap = JobisButton(style: .main).then {
        $0.setText("완료")
        $0.isEnabled = false
    }
    public override func addView() {
        [
            titleLabel,
            newPasswordTextField,
            checkNewPasswordTextField,
            changePasswordButtonDidTap
        ].forEach(view.addSubview(_:))
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        newPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }

        checkNewPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(newPasswordTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        changePasswordButtonDidTap.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bind() {
        guard let email else { return }
        let input = RenewalPasswordViewModel.Input(
            email: email,
            newPassword: newPasswordTextField.textField.rx.text.orEmpty.asDriver(),
            checkNewPassword: checkNewPasswordTextField.textField.rx.text.orEmpty.asDriver(),
            changePasswordButtonDidTap: changePasswordButtonDidTap.rx.tap.asSignal()
        )

        let output = viewModel.transform(input)
        output.passwordErrorDescription
            .asObservable()
            .bind { description in
                self.newPasswordTextField.setDescription(description)
            }
            .disposed(by: disposeBag)

        output.checkingPasswordErrorDescription
            .asObservable()
            .bind { description in
                self.checkNewPasswordTextField.setDescription(description)
            }
            .disposed(by: disposeBag)

        output.changePasswordButtonIsEnable.asObservable()
            .bind { [weak self] isEnable in
                self?.changePasswordButtonDidTap.isEnabled = isEnable
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
    }

    public override func configureNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}
