import UIKit

public extension UILabel {
    func setJobisText(_ text: String, font: JobisFontStyle, color: UIColor) {
        self.setTextWithLineHeight(text: text, font: font, color: color)
        self.font = .jobisFont(font)
    }
}

extension UILabel {
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
        self.attributedText = attrString
    }
}
