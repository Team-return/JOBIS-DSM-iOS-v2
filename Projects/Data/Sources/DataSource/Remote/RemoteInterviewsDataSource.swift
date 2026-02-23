import RxSwift
import Domain

public protocol RemoteInterviewsDataSource {
    func fetchInterviewScheduleList(
        year: Int,
        month: Int,
        interviewType: String?,
        companyName: String?
    ) -> Single<InterviewScheduleListEntity>
    func addInterviewSchedule(req: AddInterviewScheduleRequestQuery) -> Completable
}

final class RemoteInterviewsDataSourceImpl: RemoteBaseDataSource<InterviewsAPI>, RemoteInterviewsDataSource {
    func fetchInterviewScheduleList(
        year: Int,
        month: Int,
        interviewType: String?,
        companyName: String?
    ) -> Single<InterviewScheduleListEntity> {
        request(.fetchInterviewScheduleList(year: year, month: month, interviewType: interviewType, companyName: companyName))
            .map(InterviewScheduleListResponseDTO.self)
            .map { $0.toDomain() }
    }

    func addInterviewSchedule(req: AddInterviewScheduleRequestQuery) -> Completable {
        request(.addInterviewSchedule(req)).asCompletable()
    }
}
