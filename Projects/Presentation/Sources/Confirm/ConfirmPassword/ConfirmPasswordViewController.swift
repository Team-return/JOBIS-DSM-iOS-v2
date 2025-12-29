import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class ConfirmPasswordViewController: BaseReactorViewController<ConfirmPasswordReactor> {
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

    public override func bindAction() {
        passwordTextField.textField.rx.text.orEmpty
            .map { ConfirmPasswordReactor.Action.updatePassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .map { ConfirmPasswordReactor.Action.nextButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state
            .map { $0.passwordError }
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .bind(onNext: { [weak self] error in
                self?.passwordTextField.setDescription(.error(description: error))
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isNextButtonEnabled }
            .distinctUntilChanged()
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
    }

    public override func configureNavigation() {
        self.setSmallTitle(title: "")
        self.navigationItem.largeTitleDisplayMode = .never
    }
}
