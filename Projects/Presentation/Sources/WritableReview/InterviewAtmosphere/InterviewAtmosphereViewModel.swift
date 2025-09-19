import Foundation
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class InterviewAtmosphereViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    private let fetchReviewQuestionsUseCase: FetchReviewQuestionsUseCase

    public struct Input {
        let viewWillAppear: Observable<Void>
        let atmosphereText: Observable<String>
        let nextButtonDidTap: Observable<Void>
    }

    public struct Output {
        let isNextButtonEnabled: Observable<Bool>
        let characterCount: Observable<Int>
        let currentQuestion: Observable<String>
        let isLastQuestion: Observable<Bool>
        let questions: Observable<[QuestionEntity]>
        let currentQuestionIndex: Observable<Int>
        let loadAnswerForCurrentQuestion: Observable<String>
    }

    private let questionsRelay = BehaviorRelay<[QuestionEntity]>(value: [])
    private let currentQuestionIndexRelay = BehaviorRelay<Int>(value: 0)
    private let answersRelay = BehaviorRelay<[String]>(value: [])

    public init(fetchReviewQuestionsUseCase: FetchReviewQuestionsUseCase) {
        self.fetchReviewQuestionsUseCase = fetchReviewQuestionsUseCase
    }

    public func transform(_ input: Input) -> Output {
        input.viewWillAppear
            .flatMapLatest { [weak self] _ -> Observable<[QuestionEntity]> in
                guard let self = self else { return .empty() }
                return self.fetchReviewQuestionsUseCase()
                    .asObservable()
                    .catch { error in
                        print("질문 로딩 실패: \(error)")
                        return .just([])
                    }
            }
            .do(onNext: { [weak self] questions in
                let emptyAnswers = Array(repeating: "", count: questions.count)
                self?.answersRelay.accept(emptyAnswers)
                self?.currentQuestionIndexRelay.accept(0)
            })
            .bind(to: questionsRelay)
            .disposed(by: disposeBag)

        let loadAnswerForCurrentQuestion = currentQuestionIndexRelay
            .withLatestFrom(answersRelay) { index, answers in
                return index < answers.count ? answers[index] : ""
            }
        let effectiveText = Observable.merge(
            input.atmosphereText,
            loadAnswerForCurrentQuestion
        )

        let isNextButtonEnabled = effectiveText
            .map { text in
                let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                return !trimmedText.isEmpty && trimmedText.count <= 500
            }
            .distinctUntilChanged()

        let characterCount = effectiveText
            .map { $0.count }
            .distinctUntilChanged()

        let currentQuestion = Observable.combineLatest(
            questionsRelay,
            currentQuestionIndexRelay
        )
        .map { questions, index -> String in
            guard index < questions.count else { return "질문을 불러오는 중..." }
            return "Q. \(questions[index].question)"
        }
        .distinctUntilChanged()
        .share(replay: 1, scope: .whileConnected)

        let isLastQuestion = Observable.combineLatest(
            questionsRelay,
            currentQuestionIndexRelay
        )
        .map { questions, index in
            return index >= questions.count - 1
        }
        .distinctUntilChanged()

        input.nextButtonDidTap
            .withLatestFrom(
                Observable.combineLatest(
                    questionsRelay,
                    currentQuestionIndexRelay,
                    isLastQuestion,
                    answersRelay,
                    input.atmosphereText.take(1)
                )
            )
            .subscribe(onNext: { [weak self] questions, currentIndex, isLast, answers, currentText in
                guard let self = self else { return }

                var updatedAnswers = answers
                if currentIndex < updatedAnswers.count {
                    updatedAnswers[currentIndex] = currentText
                    self.answersRelay.accept(updatedAnswers)
                }

                if isLast {
                    self.completeReview(questions: questions, answers: updatedAnswers)
                } else {
                    self.moveToNextQuestion()
                }
            })
            .disposed(by: disposeBag)

        return Output(
            isNextButtonEnabled: isNextButtonEnabled,
            characterCount: characterCount,
            currentQuestion: currentQuestion,
            isLastQuestion: isLastQuestion,
            questions: questionsRelay.asObservable(),
            currentQuestionIndex: currentQuestionIndexRelay.asObservable(),
            loadAnswerForCurrentQuestion: loadAnswerForCurrentQuestion
        )
    }

    private func moveToNextQuestion() {
        let currentIndex = currentQuestionIndexRelay.value
        let questions = questionsRelay.value

        if currentIndex < questions.count - 1 {
            currentQuestionIndexRelay.accept(currentIndex + 1)
        }
    }

    private func completeReview(questions: [QuestionEntity], answers: [String]) {
        let qnAs = zip(questions, answers).map { question, answer in
            QnAEntity(id: question.id, question: question.question, answer: answer)
        }
        steps.accept(InterviewAtmosphereStep.addQuestionIsRequired)
    }

    public func getCurrentAnswers() -> [String] {
        return answersRelay.value
    }

    public func getQnAs() -> [QnAEntity] {
        let questions = questionsRelay.value
        let answers = answersRelay.value

        return zip(questions, answers).map { question, answer in
            QnAEntity(id: question.id, question: question.question, answer: answer)
        }
    }
}
