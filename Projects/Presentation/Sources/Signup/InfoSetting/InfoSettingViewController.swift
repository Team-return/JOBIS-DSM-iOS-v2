import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public class InfoSettingViewController: BaseViewController<InfoSettingViewModel> {
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
    private let nextPublishRelay = PublishRelay<Void>()

    private func next() {
        self.nextPublishRelay.accept(())
    }

    public override func attribute() {
        setLargeTitle(title: "개인정보를 입력해주세요")

        gcnTextField.textField.rx.text.orEmpty
            .observe(on: MainScheduler.asyncInstance)
            .limitWithOnlyInt(4) { [weak self] in
                self?.gcnTextField.textField.resignFirstResponder()
                self?.next()
            }
            .bind(to: gcnTextField.textField.rx.text )
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.next()
            })
            .disposed(by: disposeBag)
    }
    public override func bind() {
        let input = InfoSettingViewModel.Input(
            name: nameTextField.textField.rx.text.orEmpty.asDriver(),
            gcn: gcnTextField.textField.rx.text.orEmpty.asDriver(),
            nextButtonDidTap: nextPublishRelay.asSignal()
        )
        let output = viewModel.transform(input)
        output.nameErrorDescription
            .bind { [self] description in
                nameTextField.setDescription(description)
            }
            .disposed(by: disposeBag)
        output.gcnErrorDescription
            .bind { [self] description in
                gcnTextField.setDescription(description)
            }
            .disposed(by: disposeBag)
    }
    public override func addView() {
        [
            nameTextField,
            gcnTextField,
            nextButton
        ].forEach { self.view.addSubview($0) }
    }
    public override func layout() {
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
}
