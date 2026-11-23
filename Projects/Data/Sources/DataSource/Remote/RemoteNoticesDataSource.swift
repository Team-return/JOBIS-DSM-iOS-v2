import RxSwift
import RxCocoa
import Domain

public protocol RemoteNoticesDataSource {
    func fetchNoticeList(page: Int) -> Single<[NoticeEntity]>
    func fetchNoticeDetail(id: Int) -> Single<NoticeDetailEntity>
}

final class RemoteNoticesDataSourceDataSourceImpl: RemoteBaseDataSource<NoticeAPI>, RemoteNoticesDataSource {
    public func fetchNoticeList(page: Int) -> Single<[NoticeEntity]> {
        request(.fetchNoticeList(page: page))
            .map(NoticeListResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func fetchNoticeDetail(id: Int) -> Single<NoticeDetailEntity> {
        request(.fetchNoticeDetail(id: id))
            .map(NoticeDetailResponseDTO.self)
            .map { $0.toDomain() }
    }
}
