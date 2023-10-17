import Foundation

// swiftlint: disable identifier_name
public enum DepartmentType: String, Codable {
    case softwareDevelop = "SOFTWARE_DEVELOP"
    case embeddedSoftware = "EMBEDDED_SOFTWARE"
    case informationSecurity = "INFORMATION_SECURITY"
    case ai = "AI_SOFTWARE"
    case common = "COMMON"

    public func localizedString() -> String {
        switch self {
        case .softwareDevelop:
            return "소프트웨어개발과"

        case .embeddedSoftware:
            return "임베디드소프트웨어개발과"

        case .informationSecurity:
            return "정보보안과"

        case .ai:
            return "인공지능소프트웨어개발과"

        case .common:
            return "공통과정"
        }
    }
}
// swiftlint: enable identifier_name
