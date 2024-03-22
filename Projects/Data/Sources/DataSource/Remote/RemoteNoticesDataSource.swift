import RxSwift
import RxCocoa
import Domain

public protocol RemoteNoticesDataSource {
    func fetchNoticeList() -> Single<[NoticeEntity]>
    func fetchNoticeDetail(id: Int) -> Single<NoticeDetailEntity>
}

final class RemoteNoticesDataSourceDataSourceImpl: RemoteBaseDataSource<NoticeAPI>, RemoteNoticesDataSource {
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
