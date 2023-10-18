import Foundation

public struct CodeEntity: Equatable, Hashable {
    public let code: Int
    public let keyword: String

    public init(code: Int, keyword: String) {
        self.code = code
        self.keyword = keyword
    }
}
