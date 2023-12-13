import UIKit

public extension UIViewController {
    func showTabbar() {
        UIView.tabbarAnimate { [weak self] in
            self?.tabBarController?.tabBar.alpha = 1
            guard let tabBarFrame = self?.tabBarController?.tabBar.frame else { return }
            self?.tabBarController?.tabBar.frame.origin.y -= (tabBarFrame.height * 2)
            self?.navigationController?.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.tabBarController?.tabBar.isHidden = false
        }
    }

    func hideTabbar() {
        UIView.tabbarAnimate { [weak self] in
            self?.tabBarController?.tabBar.alpha = 0
            guard let tabBarFrame = self?.tabBarController?.tabBar.frame else { return }
            self?.tabBarController?.tabBar.frame.origin.y = tabBarFrame.maxY + tabBarFrame.height
            self?.navigationController?.view.layoutIfNeeded()
        }
    }
}

private extension UIView {
    static func tabbarAnimate(
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .transitionCrossDissolve,
            animations: animations,
            completion: completion
        )
    }
}
