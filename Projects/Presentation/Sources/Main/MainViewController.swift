import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public class MainViewController: BaseViewController<MainViewModel> {
    let loading = UIActivityIndicatorView().then {
        $0.style = .medium
    }
    let label = UILabel().then {
        $0.setJobisText("개인정보를 입력해주세요", font: .pageTitle)
    }
    let signinButton = UIButton().then {
        $0.setJobisText("로그인", font: .pageTitle, color: .blue)
    }

    let tokenButton = UIButton().then {
        $0.setTitle("토큰재발급", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }

    public override func layout() {
        signinButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        tokenButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(signinButton.snp.bottom).offset(30)
        }
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(signinButton.snp.top).offset(-30)
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
            loading
        ].forEach { self.view.addSubview($0) }
    }

    public override func bind() {
        let input = MainViewModel.Input(
            signinButtonDidTap: signinButton.rx.tap.asSignal(),
            reissueButtonDidTap: tokenButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input)
        output.string
            .bind {
                self.label.text = $0
            }
            .disposed(by: disposeBag)
        output.isLoading
            .subscribe(onNext: { [self] bool in
                bool ? loading.startAnimating() : loading.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}
