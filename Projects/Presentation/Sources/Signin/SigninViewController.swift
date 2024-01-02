import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class SigninViewController: BaseReactorViewController<SigninReactor> {
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
    public let emailTextField = JobisTextField().then {
        $0.setTextField(
            title: "이메일",
            placeholder: "example",
            textFieldType: .email
        )
    }
    public let passwordTextField = JobisTextField().then {
        $0.setTextField(
            title: "비밀번호",
            placeholder: "비밀번호를 입력해주세요",
            textFieldType: .secure
        )
    }
    public let signinButton = JobisButton(style: .main).then {
        $0.setText("로그인")
    }
    let signinPublishRelay = PublishRelay<Void>()

    func signin() {
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

    public override func bind(reactor: SigninReactor) {
        emailTextField.textField.rx.text.orEmpty
            .map { SigninReactor.Action.updateEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        passwordTextField.textField.rx.text.orEmpty
            .map { SigninReactor.Action.updatePassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        signinButton.rx.tap
            .map { SigninReactor.Action.signinButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.emailError }
            .filter { $0 != ""}
            .subscribe(onNext: {
                self.emailTextField.setDescription(.error(description: $0))
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.passwordError }
            .filter { $0 != ""}
            .subscribe(onNext: {
                self.passwordTextField.setDescription(.error(description: $0))
            })
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
    public override func setLayout() {
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
