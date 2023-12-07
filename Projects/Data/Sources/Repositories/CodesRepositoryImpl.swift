import RxSwift
import Domain

struct CodesRepositoryImpl: CodesRepository {
    private let remoteCodesDataSource: any RemoteCodesDataSource

    init(remoteCodesDataSource: any RemoteCodesDataSource) {
        self.remoteCodesDataSource = remoteCodesDataSource
    }

    func fetchCodeList(keyword: String?, type: CodeType, parentCode: String?) -> Single<[CodeEntity]> {
        remoteCodesDataSource.fetchCodeList(keyword: keyword, type: type, parentCode: parentCode)
    }
}
