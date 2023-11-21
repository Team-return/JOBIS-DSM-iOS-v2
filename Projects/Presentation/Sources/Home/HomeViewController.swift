import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public class HomeViewController: BaseViewController<HomeViewModel> {
    let loading = UIActivityIndicatorView().then {
        $0.style = .medium
    }
    let label = UILabel().then {
        $0.setJobisText("개인정보를 입력해주세요", font: .pageTitle, color: .black)
    }

    let signinButton = JobisButton(style: .main).then {
        $0.setText("로그인")
    }

    let tokenButton = JobisButton(style: .sub).then {
        $0.setText("토큰 재발급")
        $0.isEnabled = false
    }

    let tokenDeleteButton = JobisButton(style: .sub).then {
        $0.setText("토큰 삭제")
    }

    public override func layout() {
        signinButton.snp.makeConstraints {
            $0.bottom.equalTo(tokenButton.snp.top).inset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        tokenButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        tokenDeleteButton.snp.makeConstraints {
            $0.bottom.equalTo(signinButton.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview()
        }
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        loading.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(label.snp.top).offset(-30)
        }
    }

    public override func addView() {
        [
            signinButton,
            tokenButton,
            label,
            loading,
            tokenDeleteButton
        ].forEach { self.view.addSubview($0) }
    }

    public override func bind() {
        tokenDeleteButton.rx.tap
            .subscribe(onNext: {
                KeychainImpl().delete(type: .refreshToken)
                print(KeychainImpl().load(type: .refreshToken))
            }).disposed(by: disposeBag)
        let input = HomeViewModel.Input(
            signinButtonDidTap: signinButton.rx.tap.asSignal(),
            reissueButtonDidTap: tokenButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input)
        output.string
            .bind {
                self.label.text = $0
                self.tokenButton.isEnabled = true
            }
            .disposed(by: disposeBag)
        output.isLoading
            .subscribe(onNext: { [self] bool in
                bool ? loading.startAnimating() : loading.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}
