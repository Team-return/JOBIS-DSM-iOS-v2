import UIKit

public extension UILabel {
    func setJobisText(_ text: String, font: JobisFontStyle, color: UIColor? = nil, range: String? = nil) {
        self.setTextWithLineHeight(text: text, font: font, color: color, range: range)
        self.font = .jobisFont(font)
        guard let color else { return }
    }
}

extension UILabel {
    func setTextWithLineHeight(text: String?, font: JobisFontStyle, color: UIColor?, range: String?) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = font.lineHeight()
            style.minimumLineHeight = font.lineHeight()

            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (font.lineHeight() - font.size()) / 4,
                .foregroundColor: color ?? .GrayScale.gray90
            ]

            let attrString = NSMutableAttributedString(string: text,
                                                       attributes: attributes)
            attrString.addAttribute(.foregroundColor,
                                    value: UIColor.Main.blue1,
                                    range: (text as NSString).range(of: range ?? "")
            )
            self.attributedText = attrString
        }
    }
}
