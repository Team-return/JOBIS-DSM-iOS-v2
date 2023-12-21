import UIKit
import Lottie

public class JobisLottieView: UIView {
    public enum JobisLottie: String {
        case onboarding = "OnboardingLottie"
    }

    private var lottieAnimationView: LottieAnimationView?

    public init(_ type: JobisLottie) {
        super.init(frame: .zero)
        self.lottieAnimationView = .init(name: "OnboardingLottie", bundle: .module)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
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
