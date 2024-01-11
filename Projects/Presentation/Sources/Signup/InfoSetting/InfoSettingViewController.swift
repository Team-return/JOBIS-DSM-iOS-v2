import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class InfoSettingViewController: SignupViewController<InfoSettingViewModel> {
    private let nameTextField = JobisTextField().then {
        $0.setTextField(title: "이름", placeholder: "홍길동")
    }
    private let gcnTextField = JobisTextField().then {
        $0.textField.keyboardType = .numberPad
        $0.setTextField(title: "학번", placeholder: "학번 4자리를 입력해주세요")
    }
    private let nextButton = JobisButton(style: .main).then {
        $0.setText("다음")
    }

    public override func addView() {
        [
            nameTextField,
            gcnTextField,
            nextButton
        ].forEach { self.view.addSubview($0) }
    }

    public override func setLayout() {
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        gcnTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bind() {
        let input = InfoSettingViewModel.Input(
            name: nameTextField.textField.rx.text.orEmpty.asDriver(),
            gcn: gcnTextField.textField.rx.text.orEmpty.asDriver(),
            nextButtonDidTap: nextPublishRelay.asSignal()
        )
        let output = viewModel.transform(input)

        output.nameErrorDescription
            .bind { [weak self] description in
                self?.nameTextField.setDescription(description)
            }
            .disposed(by: disposeBag)

        output.gcnErrorDescription
            .bind { [weak self] description in
                self?.gcnTextField.setDescription(description)
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        nameTextField.textField.delegate = self
        gcnTextField.textField.delegate = self

        gcnTextField.textField.rx.text.orEmpty
            .observe(on: MainScheduler.asyncInstance)
            .limitWithOnlyInt(4) { [weak self] in
                self?.gcnTextField.textField.resignFirstResponder()
                self?.nextSignupStep()
            }
            .bind(to: gcnTextField.textField.rx.text )
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.nextSignupStep()
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setLargeTitle(title: "개인정보를 입력해주세요")
    }
}

extension InfoSettingViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField.textField {
            self.gcnTextField.textField.becomeFirstResponder()
        }
        return true
    }
}
