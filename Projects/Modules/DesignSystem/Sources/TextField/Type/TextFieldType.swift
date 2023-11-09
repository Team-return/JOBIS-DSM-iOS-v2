import Foundation

public enum TextFieldType: Equatable {
    case email
    case emailWithbutton(buttonTitle: String)
    case secure
    case time
    case none
}
