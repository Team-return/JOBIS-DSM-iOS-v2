import Domain

struct CodeListResponseDTO: Decodable {
    let codes: [CodeResponseDTO]
}

struct CodeResponseDTO: Decodable {
    let code: Int
    let keyword: String
}

extension CodeListResponseDTO {
    func toDomain() -> [CodeEntity] {
        codes.map {
            CodeEntity(code: $0.code, keyword: $0.keyword)
        }
    }
}
