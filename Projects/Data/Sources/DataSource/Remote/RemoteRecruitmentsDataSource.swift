import RxSwift
import Domain

protocol RemoteRecruitmentsDataSource {
    func fetchRecruitmentDetail(id: String) -> Single<RecruitmentDetailEntity>
    func fetchRecruitmentList(
        page: Int, jobCode: String?, techCode: [String]?, name: String?
    ) -> Single<[RecruitmentEntity]>
}

final class RemoteRecruitmentsDataSourceImpl: RemoteBaseDataSource<RecruitmentsAPI>, RemoteRecruitmentsDataSource {
    func fetchRecruitmentDetail(id: String) -> Single<RecruitmentDetailEntity> {
        request(.fetchRecruitmentDetail(id: id))
            .map(RecruitmentDetailResponseDTO.self)
            .map { $0.toDomain() }
    }

    func fetchRecruitmentList(
        page: Int, jobCode: String?, techCode: [String]?, name: String?
    ) -> Single<[RecruitmentEntity]> {
        request(.fetchRecruitmentList(page: page, jobCode: jobCode, techCode: techCode, name: name))
            .map(RecruitmentListResponseDTO.self)
            .map { $0.toDomain() }
    }
}
