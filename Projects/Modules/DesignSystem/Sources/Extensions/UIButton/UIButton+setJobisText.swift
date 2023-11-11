import UIKit

public extension UIButton {
    func setJobisText(_ text: String, font: JobisFontStyle, color: UIColor) {
        self.setTextWithLineHeight(text: text, font: font, color: color)
        self.titleLabel?.font = .jobisFont(font)
        self.setTitleColor(color, for: .normal)
    }
}

extension UIButton {
    func setTextWithLineHeight(text: String, font: JobisFontStyle, color: UIColor) {
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = font.lineHeight()
        style.minimumLineHeight = font.lineHeight()

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (font.lineHeight() - font.size()) / 4,
            .foregroundColor: color
        ]

        let attrString = NSMutableAttributedString(string: text, attributes: attributes)
        self.titleLabel?.attributedText = attrString
        self.setTitle(text, for: .normal)
    }
}
