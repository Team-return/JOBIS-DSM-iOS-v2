import UIKit
import SnapKit

public extension UIViewController {
    func showJobisToast(text: String) {
        let jobisToast = JobisToast(text: text)
        let animationOption = UIView.AnimationOptions.transitionCrossDissolve
        self.view.addSubview(jobisToast)
        resetToast(toast: jobisToast)

        UIView.animate(withDuration: 0.3, delay: 0, options: animationOption) { [self] in
            jobisToast.alpha = 1
            jobisToast.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(12).priority(1000)
            }
            self.view.layoutIfNeeded()
        }

        UIView.animate(withDuration: 0.3, delay: 3, options: animationOption, animations: { [self] in
            jobisToast.alpha = 0
            resetToast(toast: jobisToast)
        }, completion: { _ in
            jobisToast.removeFromSuperview()
        })
    }

    private func resetToast(toast: JobisToast) {
        self.view.layoutIfNeeded()
        toast.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.snp.bottom)
        }
    }
}
