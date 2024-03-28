import UIKit
import SnapKit
import Then
import DesignSystem

public class BaseTabBarController: UITabBarController,
                                   SetLayoutable,
                                   AddViewable {
    private let stroke = UIView().then {
        $0.backgroundColor = .GrayScale.gray30
    }
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .GrayScale.gray90
        self.tabBar.unselectedItemTintColor = .GrayScale.gray50
        self.tabBar.backgroundColor = .GrayScale.gray10
        self.delegate = self

        addView()
        setLayout()
    }

    public func addView() {
        self.tabBar.addSubview(stroke)
    }

    public func setLayout() {
        stroke.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-1)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    public override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.impactFeedbackGenerator.impactOccurred()
    }
}

extension BaseTabBarController: UITabBarControllerDelegate {
    public func tabBarController(
        _ tabBarController: UITabBarController,
        animationControllerForTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        TabbarSlideAnimator(viewControllers: self.viewControllers)
    }
}

final class TabbarSlideAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum SlideDirection {
        case leftToRight
        case rightToLeft
    }
    private var slideDirection: SlideDirection = .leftToRight
    private let duration = 0.15
    private let viewControllers: [UIViewController]?

    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
        else { return }

        self.setSlideDirection(using: transitionContext)

        let container = transitionContext.containerView.then {
            $0.backgroundColor = .GrayScale.gray10
        }
        let distanceX = self.slideDirection == .rightToLeft
            ? container.frame.width / 10
            : -(container.frame.width / 10)

        [
            fromView,
            toView
        ].forEach(container.addSubview(_:))

        toView.layoutIfNeeded()
        toView.center.x += distanceX
        toView.alpha = 0.0

        UIView.animateKeyframes(
            withDuration: self.duration,
            delay: 0,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 3/4) {
                    fromView.center.x -= distanceX * (3/4)
                    toView.center.x -= distanceX * (3/4)
                    fromView.alpha = 0.0
                }

                UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4) {
                    fromView.center.x -= distanceX * (1/4)
                    toView.center.x -= distanceX * (1/4)
                    toView.alpha = 1.0
                }
            },
            completion: {
                transitionContext.completeTransition($0)
                fromView.alpha = 1.0
            }
        )
    }

    private func setSlideDirection(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else { return }

        self.slideDirection = getIndex(fromVC) ?? 0 > getIndex(toVC) ?? 0 ? .leftToRight : .rightToLeft
    }

    private func getIndex(_ forViewController: UIViewController) -> Int? {
        guard let viewControllers = self.viewControllers else { return nil }

        for (index, viewController) in viewControllers.enumerated()
        where viewController == forViewController { return index }

        return nil
    }
}
