import RxSwift
import Domain

final class RecruitmentsRepositoryImpl: RecruitmentsRepository {
    private let remoteRecruitmentsDataSource: any RemoteRecruitmentsDataSource

    init(remoteRecruitmentsDataSource: any RemoteRecruitmentsDataSource) {
        self.remoteRecruitmentsDataSource = remoteRecruitmentsDataSource
    }

    func fetchRecruitmentDetail(id: String) -> Single<RecruitmentDetailEntity> {
        remoteRecruitmentsDataSource.fetchRecruitmentDetail(id: id)
    }

    func fetchRecruitmentList(
        page: Int, jobCode: String?, techCode: [String]?, name: String?
    ) -> Single<[RecruitmentEntity]> {
        remoteRecruitmentsDataSource.fetchRecruitmentList(page: page, jobCode: jobCode, techCode: techCode, name: name)
    }
}
