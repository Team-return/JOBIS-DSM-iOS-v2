import UIKit
import Domain
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then
import Core
import DesignSystem
import ReactorKit

public final class GenderSettingViewController: BaseReactorViewController<GenderSettingReactor> {
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

    public override func bindAction() {
        maleSelectorButton.rx.tap
            .map { GenderSettingReactor.Action.selectGender(.man) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        femaleSelectorButton.rx.tap
            .map { GenderSettingReactor.Action.selectGender(.woman) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .map { GenderSettingReactor.Action.nextButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.gender }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind { [weak self] gender in
                self?.maleSelectorButton.isSelectedGender = gender == .man
                self?.femaleSelectorButton.isSelectedGender = gender == .woman
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.isNextButtonEnabled }
            .distinctUntilChanged()
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {}

    public override func configureNavigation() {
        setLargeTitle(title: "성별을 선택해주세요")
    }
}
