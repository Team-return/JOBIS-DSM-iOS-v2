import RxSwift
import Domain

public protocol CodesRemote {
    func fetchCodeList(keyword: String?, type: CodeType, parentCode: String?) -> Single<[CodeEntity]>
}

final class CodesRemoteImpl: BaseRemote<CodesAPI>, CodesRemote {
    func fetchCodeList(keyword: String?, type: CodeType, parentCode: String?) -> Single<[CodeEntity]> {
        request(.fetchCodeList(keyword: keyword, type: type, parentCode: parentCode))
            .map(CodeListResponseDTO.self)
            .map { $0.toDomain() }
    }
}
