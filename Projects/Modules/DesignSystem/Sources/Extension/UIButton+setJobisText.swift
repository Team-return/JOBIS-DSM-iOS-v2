import UIKit

public extension UIButton {
    func setJobisText(_ text: String, font: JobisFontStyle, color: UIColor? = nil) {
        self.setTextWithLineHeight(text: text, lineHeight: font.lineHeight())
        self.titleLabel?.font = .jobisFont(font)
        guard let color else { return }
        self.setTitleColor(color, for: .normal)
    }
}

public extension UIButton {
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
        if let textLabel = self.titleLabel,
           let text = textLabel.text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight

            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - textLabel.font.lineHeight) / 4
            ]

            let attrString = NSAttributedString(
                string: text,
                attributes: attributes
            )
            self.titleLabel?.attributedText = attrString
        }
        self.setTitle(text, for: .normal)
    }
}
