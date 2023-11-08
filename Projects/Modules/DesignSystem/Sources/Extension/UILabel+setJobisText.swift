import UIKit

public extension UILabel {
    func setJobisText(_ text: String, font: JobisFontStyle, color: UIColor? = nil) {
        self.setTextWithLineHeight(text: text, font: font)
        self.font = .jobisFont(font)
        guard let color else { return }
        self.textColor = color
    }
}

extension UILabel {
    func setTextWithLineHeight(text: String?, font: JobisFontStyle) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = font.lineHeight()
            style.minimumLineHeight = font.lineHeight()

            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (font.lineHeight() - font.size()) / 4
            ]

            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
}
