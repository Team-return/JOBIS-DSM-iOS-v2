import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class RenewalPasswordViewController: BaseReactorViewController<RenewalPasswordReactor> {
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

    public override func bindAction() {
        newPasswordTextField.textField.rx.text.orEmpty
            .map { RenewalPasswordReactor.Action.updateNewPassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        checkNewPasswordTextField.textField.rx.text.orEmpty
            .map { RenewalPasswordReactor.Action.updateCheckNewPassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        changePasswordButtonDidTap.rx.tap
            .map { RenewalPasswordReactor.Action.changePasswordButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.passwordError }
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] error in
                self?.newPasswordTextField.setDescription(error)
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.checkPasswordError }
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] error in
                self?.checkNewPasswordTextField.setDescription(error)
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.isButtonEnabled }
            .distinctUntilChanged()
            .bind(to: changePasswordButtonDidTap.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}
