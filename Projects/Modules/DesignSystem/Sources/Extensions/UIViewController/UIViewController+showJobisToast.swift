import UIKit
import Then
import SnapKit

public extension UIViewController {
    func showJobisToast(text: String) {
        let jobisToast = JobisToast(text: text)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { [self] in
            setToastLayout(toast: jobisToast)
        }
        UIView.animate(withDuration: 2, delay: 2.5, options: .curveEaseOut, animations: {
            jobisToast.alpha = 0.0
        }, completion: { _ in
            jobisToast.removeFromSuperview()
        })
    }

    private func setToastLayout(toast jobisToast: JobisToast) {
        self.view.addSubview(jobisToast)
        jobisToast.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(12).priority(1000)
        }
    }
}
