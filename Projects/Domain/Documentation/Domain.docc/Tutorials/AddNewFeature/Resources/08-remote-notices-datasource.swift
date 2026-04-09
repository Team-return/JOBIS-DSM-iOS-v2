import RxSwift
import Domain

// 프로토콜: Domain에서 사용하는 인터페이스
public protocol RemoteNoticesDataSource {
    func fetchNoticeList() -> Single<[NoticeEntity]>
    func fetchNoticeDetail(id: Int) -> Single<NoticeDetailEntity>
}

// 구현체: RemoteBaseDataSource<API>를 상속해 request()를 사용
final class RemoteNoticesDataSourceImpl: RemoteBaseDataSource<NoticeAPI>, RemoteNoticesDataSource {

    public func fetchNoticeList() -> Single<[NoticeEntity]> {
        request(.fetchNoticeList)
            .map(NoticeListResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func fetchNoticeDetail(id: Int) -> Single<NoticeDetailEntity> {
        request(.fetchNoticeDetail(id: id))
            .map(NoticeDetailResponseDTO.self)
            .map { $0.toDomain() }
    }
}
