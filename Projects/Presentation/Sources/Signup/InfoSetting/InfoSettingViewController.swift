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

    private func checkAndTrimId(_ id: String) -> Bool {
        if id.count > 4 {
            let index = id.index(id.startIndex, offsetBy: 4)
            self.gcnTextField.textField.text = String(id[..<index])
            return true
        }
        return false
    }

    public override func attribute() {
        setLargeTitle(title: "개인정보를 입력해주세요")

        gcnTextField.textField.rx.text.orEmpty
                .map(checkAndTrimId(_:))
                .subscribe(onNext: {
                    if $0 {
                        self.gcnTextField.textField.resignFirstResponder()
                    }
                })
                .disposed(by: disposeBag)
    }
    public override func bind() {
        let input = InfoSettingViewModel.Input(
            name: nameTextField.textField.rx.text.orEmpty.asDriver(),
            gcn: gcnTextField.textField.rx.text.orEmpty.asDriver(),
            nextButtonDidTap: nextButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input)
        output.nameErrorDescription
            .bind { [self] description in
                print("name \(description)")
                nameTextField.setDescription(.error(description: description))
            }
            .disposed(by: disposeBag)
        output.gcnErrorDescription
            .bind { [self] description in
                print("gcn \(description)")
                gcnTextField.setDescription(.error(description: description))
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
