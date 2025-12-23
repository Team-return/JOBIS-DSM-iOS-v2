import UIKit
import WebKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import ReactorKit

public final class PrivacyViewController: BaseReactorViewController<PrivacyReactor> {
    private let privacyWebView = WKWebView().then {
        let url = URL(
            string: Bundle.main.object(forInfoDictionaryKey: "PRIVACY_WEB_URL") as? String ?? ""
        ) ?? URL(string: "https://www.google.com")!
        let request = URLRequest(url: url)
        $0.load(request)
    }
    private let signupButton = JobisButton(style: .main).then {
        $0.setText("동의할게요")
        $0.isEnabled = false
    }

    public override func addView() {
        [
            privacyWebView,
            signupButton
        ].forEach { self.view.addSubview($0) }
    }

    public override func setLayout() {
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

    public override func bindAction() {
        signupButton.rx.tap
            .map { PrivacyReactor.Action.signupButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        privacyWebView.scrollView.rx.contentOffset
            .filter { [weak self] _ in
                !(self?.reactor.currentState.isSignupButtonEnabled ?? false)
            }
            .distinctUntilChanged()
            .filter { [weak self] point in
                guard let self = self else { return false }
                return self.checkScrollIsBottom(yOffset: point.y)
            }
            .map { _ in PrivacyReactor.Action.enableSignupButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.isSignupButtonEnabled }
            .distinctUntilChanged()
            .bind(to: signupButton.rx.isEnabled)
            .disposed(by: disposeBag)

        reactor.state.map { $0.signupError }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind { [weak self] errorMessage in
                self?.showJobisToast(text: errorMessage, inset: 92)
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {}

    public override func configureNavigation() {
        setLargeTitle(title: "아래의 사항을 읽고 동의해주세요")
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
