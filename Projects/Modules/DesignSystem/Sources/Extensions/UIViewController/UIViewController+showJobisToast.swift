import UIKit
import SnapKit

public extension UIViewController {
    func showJobisToast(text: String, inset: CGFloat) {
        let jobisToast = JobisToast(text: text)
        let animationOption = UIView.AnimationOptions.transitionCrossDissolve
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first

        window?.addSubview(jobisToast)
        resetToast(toast: jobisToast, inset: inset)

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: animationOption
        ) {
            jobisToast.alpha = 1
        }

        UIView.animate(
            withDuration: 0.3,
            delay: 1.25,
            options: animationOption,
            animations: {
                jobisToast.alpha = 0
            }, completion: { _ in
                jobisToast.removeFromSuperview()
            }
        )
    }

    private func resetToast(toast: JobisToast, inset: CGFloat) {
        toast.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottomMargin.equalToSuperview().inset(inset)
        }
    }
}
