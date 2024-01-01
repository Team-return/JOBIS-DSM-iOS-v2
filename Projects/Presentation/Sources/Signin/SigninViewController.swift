import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class SigninViewController: BaseViewController<SigninViewModel> {
    private let titleLabel = UILabel().then {
        $0.setJobisText("JOBIS에 로그인하기", font: .pageTitle, color: .GrayScale.gray90)
        $0.setColorRange(color: .Primary.blue20, range: "JOBIS")
    }
    private let titleLineView = UIView().then {
        $0.backgroundColor = .GrayScale.gray90
    }
    private let titleImageView = UIImageView().then {
        $0.image = .jobisIcon(.door)
    }
    private let emailTextField = JobisTextField().then {
        $0.setTextField(
            title: "이메일",
            placeholder: "example",
            textFieldType: .email
        )
    }
    private let passwordTextField = JobisTextField().then {
        $0.setTextField(
            title: "비밀번호",
            placeholder: "비밀번호를 입력해주세요",
            textFieldType: .secure
        )
    }
    private let signinButton = JobisButton(style: .main).then {
        $0.setText("로그인")
    }
    private let signinPublishRelay = PublishRelay<Void>()

    private func signin() {
        self.signinPublishRelay.accept(())
    }
    public override func attribute() {
        passwordTextField.textField.delegate = self
        signinButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.signin()
            })
            .disposed(by: disposeBag)
    }
    public override func bind() {
        let input = SigninViewModel.Input(
            email: emailTextField.textField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.textField.rx.text.orEmpty.asDriver(),
            signinButtonDidTap: signinButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input)
        output.emailErrorDescription
            .bind { [weak self] description in
                self?.emailTextField.setDescription(description)
            }
            .disposed(by: disposeBag)
        output.passwordErrorDescription
            .bind { [weak self] description in
                self?.passwordTextField.setDescription(description)
            }
            .disposed(by: disposeBag)
    }
    public override func addView() {
        [
            titleLabel,
            titleLineView,
            titleImageView,
            emailTextField,
            passwordTextField,
            signinButton
        ].forEach { self.view.addSubview($0) }
    }
    public override func layout() {
        titleLabel.snp.makeConstraints {
            $0.topMargin.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(24)
        }
        titleLineView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(12)
            $0.trailing.equalTo(titleImageView.snp.leading).offset(-12)
            $0.height.equalTo(1)
        }
        titleImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.width.height.equalTo(32)
            $0.trailing.equalToSuperview().inset(24)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        signinButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
}

extension SigninViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField.textField {
            signin()
        }
        return true
    }
}
