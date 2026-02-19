import RxSwift

public struct FetchInterviewScheduleListUseCase {
    private let interviewsRepository: any InterviewsRepository

    public init(interviewsRepository: any InterviewsRepository) {
        self.interviewsRepository = interviewsRepository
    }

    public func execute(
        year: Int,
        month: Int,
        interviewType: String? = nil,
        companyName: String? = nil
    ) -> Single<InterviewScheduleListEntity> {
        interviewsRepository.fetchInterviewScheduleList(
            year: year,
            month: month,
            interviewType: interviewType,
            companyName: companyName
        )
    }
}
