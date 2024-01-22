import UIKit

public extension UILabel {
    func setRangeOfText(font: UIFont, color: UIColor, range: String) {
        guard let text = self.text else { return }
        let attrString = NSMutableAttributedString(string: text)

        attrString.addAttributes(
            [
                .font: font,
                .foregroundColor: color
            ], range: (text as NSString).range(of: range)
        )
        self.attributedText = attrString
    }
}
