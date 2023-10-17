import Foundation

public struct ReissueAuthorityEntity: Equatable {
    public let authority: AuthorityType

    public init(authority: AuthorityType) {
        self.authority = authority
    }
}
