import UIKit
import Domain
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then
import Core
import DesignSystem

public final class GenderSettingViewController: BaseViewController<GenderSettingViewModel> {
    public var name: String = ""
    public var gcn: Int = 0
    public var email: String = ""
    public var password: String = ""
    private let selectedGender = PublishRelay<GenderType>()
    private let genderSelectorStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    private let maleSelectorButton = SelectGenderButton(.man)
    private let femaleSelectorButton = SelectGenderButton(.woman)
    private let nextButton = JobisButton(style: .main).then {
        $0.setText("다음")
        $0.isEnabled = false
    }

    public override func addView() {
        [
            genderSelectorStackView,
            nextButton
        ].forEach(view.addSubview(_:))

        [
            maleSelectorButton,
            femaleSelectorButton
        ].forEach(genderSelectorStackView.addArrangedSubview(_:))
    }

    public override func setLayout() {
        genderSelectorStackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(128)
        }

        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bind() {
        let input = GenderSettingViewModel.Input(
            name: name,
            gcn: gcn,
            email: email,
            password: password,
            gender: selectedGender.asSignal(),
            nextButtonDidTap: nextButton.rx.tap.asSignal()
        )
        _ = viewModel.transform(input)
    }

    public override func configureViewController() {
        selectedGender.asObservable().bind { [weak self] gender in
            self?.nextButton.isEnabled = true
            self?.maleSelectorButton.isSelectedGender = gender == .man
            self?.femaleSelectorButton.isSelectedGender = gender == .woman
        }
        .disposed(by: disposeBag)

        maleSelectorButton.rx.tap
            .asObservable()
            .bind { [weak self] _ in
                self?.selectedGender.accept(.man)
            }
            .disposed(by: disposeBag)

        femaleSelectorButton.rx.tap
            .asObservable()
            .bind { [weak self] _ in
                self?.selectedGender.accept(.woman)
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setLargeTitle(title: "성별을 선택해주세요")
    }
}
