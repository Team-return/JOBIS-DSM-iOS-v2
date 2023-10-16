import Foundation

public enum AuthorityType: String, Decodable {
    case student = "STUDENT"
    case company = "COMPANY"
    case teacher = "TEACHTER"
    case developer = "DEVELOPER"
}
