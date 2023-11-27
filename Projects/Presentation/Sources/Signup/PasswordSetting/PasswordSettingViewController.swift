import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public class PasswordSettingViewController: BaseViewController<PasswordSettingViewModel> {
    private let passwordTextField = JobisTextField().then {
        $0.setTextField(
            title: "비밀번호",
            placeholder: "계정의 비밀번호를 설정해주세요.",
            descriptionType: .info(description: "8 ~ 16자, 영문자, 숫자, 특수문자 포함"),
            textFieldType: .secure
        )
    }
    private let checkingPasswordTextField = JobisTextField().then {
        $0.setTextField(title: "비밀번호 확인", placeholder: "위 비밀번호를 한 번 더 입력해주세요.", textFieldType: .secure)
    }
    private let nextButton = JobisButton(style: .main).then {
        $0.setText("다음")
    }

    public override func attribute() {
        setLargeTitle(title: "비밀번호를 설정해주세요")
    }
    public override func bind() {
        let input = PasswordSettingViewModel.Input(
            password: passwordTextField.textField.rx.text.orEmpty.asDriver(),
            checkingPassword: checkingPasswordTextField.textField.rx.text.orEmpty.asDriver(),
            nextButtonDidTap: nextButton.rx.tap.asSignal()
        )

        let output = viewModel.transform(input)
        output.passwordErrorDescription
            .asObservable()
            .bind { description in
                self.passwordTextField.setDescription(description)
            }
            .disposed(by: disposeBag)

        output.checkingPasswordErrorDescription
            .asObservable()
            .bind { description in
                self.checkingPasswordTextField.setDescription(description)
            }
            .disposed(by: disposeBag)
    }
    public override func addView() {
        [
            passwordTextField,
            checkingPasswordTextField,
            nextButton
        ].forEach { self.view.addSubview($0) }
    }
    public override func layout() {
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
}
