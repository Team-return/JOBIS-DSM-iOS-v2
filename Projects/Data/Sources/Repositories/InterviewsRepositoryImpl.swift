import RxSwift
import Domain

struct InterviewsRepositoryImpl: InterviewsRepository {
    private let remoteInterviewsDataSource: any RemoteInterviewsDataSource

    init(remoteInterviewsDataSource: any RemoteInterviewsDataSource) {
        self.remoteInterviewsDataSource = remoteInterviewsDataSource
    }

    func fetchInterviewScheduleList(
        year: Int,
        month: Int,
        interviewType: String?,
        companyName: String?
    ) -> Single<InterviewScheduleListEntity> {
        remoteInterviewsDataSource.fetchInterviewScheduleList(
            year: year,
            month: month,
            interviewType: interviewType,
            companyName: companyName
        )
    }

    func addInterviewSchedule(req: AddInterviewScheduleRequestQuery) -> Completable {
        remoteInterviewsDataSource.addInterviewSchedule(req: req)
    }
}
