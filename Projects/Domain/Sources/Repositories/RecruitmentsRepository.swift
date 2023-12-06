import RxSwift

public protocol RecruitmentsRepository {
    func fetchRecruitmentDetail(id: String) -> Single<RecruitmentDetailEntity>
    func fetchRecruitmentList(
        page: Int, jobCode: String?, techCode: [String]?, name: String?
    ) -> Single<[RecruitmentEntity]>
}
