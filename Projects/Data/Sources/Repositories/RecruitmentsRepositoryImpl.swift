import RxSwift
import Domain

final class RecruitmentsRepositoryImpl: RecruitmentsRepository {
    private let recruitmentsRemote: any RecruitmentsRemote

    init(recruitmentsRemote: any RecruitmentsRemote) {
        self.recruitmentsRemote = recruitmentsRemote
    }

    func fetchRecruitmentDetail(id: String) -> Single<RecruitmentDetailEntity> {
        recruitmentsRemote.fetchRecruitmentDetail(id: id)
    }

    func fetchRecruitmentList(
        page: Int, jobCode: String?, techCode: [String]?, name: String?
    ) -> Single<[RecruitmentEntity]> {
        recruitmentsRemote.fetchRecruitmentList(page: page, jobCode: jobCode, techCode: techCode, name: name)
    }
}
