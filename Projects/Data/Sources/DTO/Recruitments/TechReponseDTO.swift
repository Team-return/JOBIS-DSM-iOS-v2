import Foundation
import Domain

struct TechReponseDTO: Decodable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, name
    }
}
