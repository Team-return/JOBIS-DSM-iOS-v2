import UIKit
import Then
import SnapKit
import Lottie

public class JobisLottieView: UIView {
    private var lottieAnimationView: LottieAnimationView?

    public init() {
        super.init(frame: .zero)

        var animation: LottieAnimation? {
            switch UITraitCollection.current.userInterfaceStyle {
            case .dark:
                AnimationAsset.darkOnboarding.animation

            default:
                AnimationAsset.lightOnboarding.animation
            }
        }

        self.lottieAnimationView = .init(animation: animation)

        self.configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)

            if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
                let animation: LottieAnimation? = {
                    switch self.traitCollection.userInterfaceStyle {
                    case .dark:
                        return AnimationAsset.darkOnboarding.animation
                    default:
                        return AnimationAsset.lightOnboarding.animation
                    }
                }()

                self.lottieAnimationView?.removeFromSuperview()
                self.lottieAnimationView = .init(animation: animation)
                self.configureView()
                self.play()
            }
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
