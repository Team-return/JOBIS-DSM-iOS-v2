import RxSwift
import Domain

protocol RemoteRecruitmentsDataSource {
    func fetchRecruitmentDetail(id: Int) -> Single<RecruitmentDetailEntity>
    func fetchRecruitmentList(
        page: Int, jobCode: String?, techCode: [String]?, name: String?, winterIntern: Bool?
    ) -> Single<[RecruitmentEntity]>
}

final class RemoteRecruitmentsDataSourceImpl: RemoteBaseDataSource<RecruitmentsAPI>, RemoteRecruitmentsDataSource {
    func fetchRecruitmentDetail(id: Int) -> Single<RecruitmentDetailEntity> {
        request(.fetchRecruitmentDetail(id: id))
            .map(RecruitmentDetailResponseDTO.self)
            .map { $0.toDomain() }
    }

    func fetchRecruitmentList(
        page: Int,
        jobCode: String?,
        techCode: [String]?,
        name: String?,
        winterIntern: Bool?
    ) -> Single<[RecruitmentEntity]> {
        request(.fetchRecruitmentList(
            page: page,
            jobCode: jobCode,
            techCode: techCode,
            name: name,
            winterIntern: winterIntern
        ))
        .map(RecruitmentListResponseDTO.self)
        .map { $0.toDomain() }
    }
}
