import UIKit

public extension UIFont {
    static func jobisFont(_ font: JobisFontStyle) -> UIFont {
        font.uiFont()
    }
}

extension JobisFontStyle {
    func lineHeight() -> CGFloat {
        switch self {
        case .pageTitle:
            return 36

        case .headLine:
            return 28

        case .subHeadLine, .body, .largeBody:
            return 24

        case .subBody, .description, .boldBody:
            return 20

        case .caption:
            return 16

        case .subcaption:
            return 14
        }
    }

    func uiFont() -> UIFont {
        let pretendard = DesignSystemFontFamily.Pretendard.self

        switch self {

        case .pageTitle:
            return pretendard.bold.font(size: 24)

        case .headLine:
            return pretendard.semiBold.font(size: 18)

        case .subHeadLine:
            return pretendard.semiBold.font(size: 16)

        case .body:
            return pretendard.medium.font(size: 16)

        case .subBody:
            return pretendard.semiBold.font(size: 14)

        case .boldBody:
            return pretendard.bold.font(size: 16)

        case .largeBody:
                return pretendard.medium.font(size: 20)

        case .description:
            return pretendard.medium.font(size: 14)

        case .caption:
            return pretendard.medium.font(size: 12)

        case .subcaption:
            return pretendard.medium.font(size: 10)
        }
    }

    func size() -> CGFloat {

        switch self {

        case .pageTitle:
            return 24

        case .headLine:
            return 18

        case .largeBody:
            return 20

        case .subHeadLine, .body, .boldBody:
            return 16

        case .subBody, .description:
            return 14

        case .caption:
            return 12

        case .subcaption:
            return 10
        }
    }
}
