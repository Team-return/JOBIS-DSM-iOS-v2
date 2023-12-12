import UIKit

public extension UIView {
    func asCircle() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layoutIfNeeded()
    }
}
