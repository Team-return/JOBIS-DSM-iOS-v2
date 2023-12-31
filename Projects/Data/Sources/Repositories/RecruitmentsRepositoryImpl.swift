import RxSwift
import Domain

struct RecruitmentsRepositoryImpl: RecruitmentsRepository {
    private let remoteRecruitmentsDataSource: any RemoteRecruitmentsDataSource

    init(remoteRecruitmentsDataSource: any RemoteRecruitmentsDataSource) {
        self.remoteRecruitmentsDataSource = remoteRecruitmentsDataSource
    }

    func fetchRecruitmentDetail(id: Int) -> Single<RecruitmentDetailEntity> {
        remoteRecruitmentsDataSource.fetchRecruitmentDetail(id: id)
    }

    func fetchRecruitmentList(
        page: Int, jobCode: String?, techCode: [String]?, name: String?
    ) -> Single<[RecruitmentEntity]> {
        remoteRecruitmentsDataSource.fetchRecruitmentList(page: page, jobCode: jobCode, techCode: techCode, name: name)
    }
}
