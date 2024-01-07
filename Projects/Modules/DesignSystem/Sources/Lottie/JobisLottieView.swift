import UIKit
import Then
import SnapKit
import Lottie

public class JobisLottieView: UIView {
    public enum JobisLottie: String {
        case onboarding = "OnboardingLottie"
    }

    private var lottieAnimationView: LottieAnimationView?

    public init(_ type: JobisLottie) {
        super.init(frame: .zero)
        self.lottieAnimationView = .init(name: type.rawValue, bundle: .module)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        guard let lottieAnimationView else { return }
        self.addSubview(lottieAnimationView)

        lottieAnimationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public func play() {
        self.lottieAnimationView?.play()
    }
}
