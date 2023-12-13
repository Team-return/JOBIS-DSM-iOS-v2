import UIKit

public extension UIViewController {
    func showTabbar() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .transitionCrossDissolve
        ) { [weak self] in
            guard let tabBarFrame = self?.tabBarController?.tabBar.frame else { return }
            self?.tabBarController?.tabBar.frame.origin.y -= (tabBarFrame.height * 2)
            self?.navigationController?.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.tabBarController?.tabBar.isHidden = false
        }
    }

    func hideTabbar() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .transitionCrossDissolve
        ) { [weak self] in
            guard let tabBarFrame = self?.tabBarController?.tabBar.frame else { return }
            self?.tabBarController?.tabBar.frame.origin.y = tabBarFrame.maxY + tabBarFrame.height
            self?.navigationController?.view.layoutIfNeeded()
        }
    }
}
