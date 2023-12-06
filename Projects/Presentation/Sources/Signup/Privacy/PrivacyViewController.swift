import UIKit
import WebKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class PrivacyViewController: BaseViewController<PrivacyViewModel> {
    public var name: String = ""
    public var gcn: Int = 0
    public var email: String = ""
    public var password: String = ""
    private let privacyWebView = WKWebView().then {
        let url = URL(string: "https://jobis-webview.team-return.com/sign-up-policy")
        let request = URLRequest(url: url!)
        $0.load(request)
    }
    private let signupButton = JobisButton(style: .main).then {
        $0.setText("동의할게요")
        $0.isEnabled = false
    }

    public override func attribute() {
        setLargeTitle(title: "아래의 사항을 읽고 동의해주세요")

        privacyWebView.scrollView.rx.contentOffset
            .filter { [weak self] _ in
                !(self?.signupButton.isEnabled ?? false)
            }
            .distinctUntilChanged()
            .bind { [weak self] point in
                guard let scrollView = self else { return }
                self?.signupButton.isEnabled = scrollView.checkScrollIsBottom(yOffset: point.y)
            }.disposed(by: disposeBag)
    }
    public override func bind() {
        let input = PrivacyViewModel.Input(
            name: name,
            gcn: gcn,
            email: email,
            password: password,
            signupButtonDidTap: signupButton.rx.tap.asSignal()
        )

        _ = viewModel.transform(input)
    }
    public override func addView() {
        [
            privacyWebView,
            signupButton
        ].forEach { self.view.addSubview($0) }
    }
    public override func layout() {
        privacyWebView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.signupButton.snp.top).offset(-12)
            $0.leading.trailing.equalToSuperview()
        }
        signupButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
}

extension PrivacyViewController {
    func checkScrollIsBottom(yOffset: CGFloat) -> Bool {
        return yOffset >= getBottomYOffset() && getBottomYOffset() > 0
    }

    private func getBottomYOffset() -> CGFloat {
        let scrollView = privacyWebView.scrollView
        let contentSize = scrollView.contentSize.height
        let frameSize = scrollView.frame.size.height
        return contentSize - frameSize
    }
}
