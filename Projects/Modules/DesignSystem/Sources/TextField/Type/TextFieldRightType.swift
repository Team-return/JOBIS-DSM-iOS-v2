import Foundation

public enum TextFieldRightType: Equatable {
    case email
    case emailWithbutton(buttonTitle: String)
    case secure
    case time
    case none
}
