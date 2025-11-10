import RxSwift

public struct FetchReviewQuestionsUseCase {
    private let reviewsRepository: any ReviewsRepository
    
    public init(reviewsRepository: any ReviewsRepository) {
        self.reviewsRepository = reviewsRepository
    }
    
    public func callAsFunction() -> Single<[QuestionEntity]> {
        reviewsRepository.fetchReviewQuestions()
    }
}
