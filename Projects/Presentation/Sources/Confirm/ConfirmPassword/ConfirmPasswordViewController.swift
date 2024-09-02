import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class ConfirmPasswordViewController: BaseViewController<ConfirmPasswordViewModel> {
    private let titleLabel = UILabel().then {
        $0.setJobisText(
            "비밀번호 변경을 위해\n현재 비밀번호를 입력해주세요",
            font: .pageTitle,
            color: .GrayScale.gray90
        )
        $0.numberOfLines = 2
    }
    private let passwordTextField = JobisTextField().then {
        $0.setTextField(
            title: "비밀번호",
            placeholder: "계정의 비밀번호를 입력해주세요.",
            textFieldType: .secure
        )
    }
    private let nextButton = JobisButton(style: .main).then {
        $0.setText("다음")
        $0.isEnabled = false
    }
    public override func addView() {
        [
            titleLabel,
            passwordTextField,
            nextButton
        ].forEach(view.addSubview(_:))
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }

        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bind() {
        let input = ConfirmPasswordViewModel.Input(
            currentPassword: passwordTextField.textField.rx.text.orEmpty.asDriver(),
            nextButtonDidTap: nextButton.rx.tap.asSignal()
        )

        let output = viewModel.transform(input)
        output.passwordErrorDescription.asObservable()
            .bind { [weak self] description in
                self?.passwordTextField.setDescription(description)
            }
            .disposed(by: disposeBag)
        output.nextButtonIsEnable.asObservable()
            .bind { [weak self] isEnable in
                self?.nextButton.isEnabled = isEnable
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
    }

    public override func configureNavigation() {
        self.setSmallTitle(title: "")
        self.navigationItem.largeTitleDisplayMode = .never
    }
}
