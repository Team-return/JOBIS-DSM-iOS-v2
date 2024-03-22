import Foundation
import Domain

struct JobResponseDTO: Decodable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, name
    }
}
