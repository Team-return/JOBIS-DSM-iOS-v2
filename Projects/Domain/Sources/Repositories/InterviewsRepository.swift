import RxSwift

public protocol InterviewsRepository {
    func fetchInterviewScheduleList(
        year: Int,
        month: Int,
        interviewType: String?,
        companyName: String?
    ) -> Single<InterviewScheduleListEntity>
    func addInterviewSchedule(req: AddInterviewScheduleRequestQuery) -> Completable
}
