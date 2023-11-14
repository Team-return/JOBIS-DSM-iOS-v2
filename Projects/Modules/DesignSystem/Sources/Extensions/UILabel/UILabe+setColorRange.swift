import UIKit

public extension UILabel {
    func setColorRange(color: UIColor, range: String) {
        guard let text = self.text,
              let textColor = self.textColor else { return }

        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: textColor]
        let attrString = NSMutableAttributedString(string: text, attributes: attributes)
        attrString.addAttribute(
            .foregroundColor,
            value: color,
            range: (text as NSString).range(of: range
                                                               )
        )
        self.attributedText = attrString
    }
}
