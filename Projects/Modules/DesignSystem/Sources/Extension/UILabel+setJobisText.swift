import UIKit

public extension UILabel {
    func setJobisText(_ text: String, font: JobisFontStyle, color: UIColor = .black) {
        self.setTextWithLineHeight(text: text, lineHeight: font.lineHeight())
        self.font = .jobisFont(font)
        self.textColor = color
    }
}

extension UILabel {
     func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight

            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 4
            ]

            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
}
