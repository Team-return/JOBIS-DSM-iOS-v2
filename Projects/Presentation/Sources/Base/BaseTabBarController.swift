import UIKit
import SnapKit
import Then
import DesignSystem
import SwiftUI
import Pulse
import PulseUI

public class BaseTabBarController: UITabBarController,
                                   SetLayoutable,
                                   AddViewable {
    
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let consoleButtonSize: CGRect = CGRect(x: 0, y: 0, width: 100, height: 40)

    private let stroke = UIView().then {
        $0.backgroundColor = .GrayScale.gray30
    }

    private lazy var consoleButton = UIButton(frame: consoleButtonSize).then {
        $0.setJobisText("Console", font: .body, color: .GrayScale.gray10)
        $0.backgroundColor = .GrayScale.gray70
        $0.layer.cornerRadius = consoleButtonSize.height / 2
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .GrayScale.gray90
        self.tabBar.unselectedItemTintColor = .GrayScale.gray50
        self.tabBar.backgroundColor = .GrayScale.gray10
        self.delegate = self

        addView()
        setLayout()

        #if DEV
        setConsoleButton()
        #endif
    }

    private func setConsoleButton() {
        self.view.addSubview(consoleButton)
        consoleButton.addTarget(self, action: #selector(touchConsoleButton), for: .touchUpInside)
        consoleButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panAction)))

        consoleButton.center = CGPoint(
            x: UIScreen.main.bounds.width - 70,
            y: UIScreen.main.bounds.height - 100
        )
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

    @objc func panAction(recognizer: UIPanGestureRecognizer) {
        
        let transition = recognizer.translation(in: consoleButton)

        if recognizer.state != .ended {
            let changedX = consoleButton.center.x + transition.x
            let changedY = consoleButton.center.y + transition.y
            consoleButton.center = CGPoint(x: changedX, y: changedY)
            recognizer.setTranslation(CGPoint.zero, in: consoleButton)
        }
    }

    @objc func touchConsoleButton() {
        let view = NavigationView {
            ConsoleView()
        }

        self.present(UIHostingController(rootView: view), animated: true)
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
