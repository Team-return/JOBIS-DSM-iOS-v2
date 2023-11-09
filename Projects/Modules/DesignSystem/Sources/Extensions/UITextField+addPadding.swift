import UIKit

public extension UITextField {
    func addLeftPadding(size: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: 0))
        self.leftViewMode = .always
    }

    func addRightPadding(size: CGFloat) {
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: 0))
        self.rightViewMode = .always
    }
}
