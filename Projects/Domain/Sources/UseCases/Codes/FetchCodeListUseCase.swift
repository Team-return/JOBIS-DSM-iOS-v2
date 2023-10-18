import RxSwift

public struct FetchCodeListUseCase {
    public init(codesRepository: CodesRepository) {
        self.codesRepository = codesRepository
    }

    private let codesRepository: CodesRepository

    public func execute(keyword: String?, type: CodeType, parentCode: String?) -> Single<[CodeEntity]> {
        codesRepository.fetchCodeList(keyword: keyword, type: type, parentCode: parentCode)
    }
}
