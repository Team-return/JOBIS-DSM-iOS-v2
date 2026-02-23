import RxSwift

public struct AddInterviewScheduleUseCase {
    private let interviewsRepository: any InterviewsRepository

    public init(interviewsRepository: any InterviewsRepository) {
        self.interviewsRepository = interviewsRepository
    }

    public func execute(req: AddInterviewScheduleRequestQuery) -> Completable {
        interviewsRepository.addInterviewSchedule(req: req)
    }
}
