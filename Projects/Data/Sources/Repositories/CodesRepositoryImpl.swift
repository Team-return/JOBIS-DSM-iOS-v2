import RxSwift
import Domain

final class CodesRepositoryImpl: CodesRepository {
    private let codesRemote: any CodesRemote

    init(codesRemote: any CodesRemote) {
        self.codesRemote = codesRemote
    }

    func fetchCodeList(keyword: String?, type: CodeType, parentCode: String?) -> Single<[CodeEntity]> {
        codesRemote.fetchCodeList(keyword: keyword, type: type, parentCode: parentCode)
    }
}
