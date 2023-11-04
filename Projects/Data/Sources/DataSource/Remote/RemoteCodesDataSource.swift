import RxSwift
import Domain

public protocol RemoteCodesDataSource {
    func fetchCodeList(keyword: String?, type: CodeType, parentCode: String?) -> Single<[CodeEntity]>
}

final class RemoteCodesDataSourceImpl: RemoteBaseDataSource<CodesAPI>, RemoteCodesDataSource {
    func fetchCodeList(keyword: String?, type: CodeType, parentCode: String?) -> Single<[CodeEntity]> {
        request(.fetchCodeList(keyword: keyword, type: type, parentCode: parentCode))
            .map(CodeListResponseDTO.self)
            .map { $0.toDomain() }
    }
}
