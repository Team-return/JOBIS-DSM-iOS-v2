import RxSwift

public protocol CodesRepository {
    func fetchCodeList(keyword: String?, type: CodeType, parentCode: String?) -> Single<[CodeEntity]>
}
