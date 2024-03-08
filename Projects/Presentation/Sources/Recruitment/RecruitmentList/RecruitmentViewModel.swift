import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class RecruitmentViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchRecruitmentListUseCase: FetchRecruitmentListUseCase
    private let bookmarkUseCase: BookmarkUseCase
    private var recruitmentData = BehaviorRelay<[RecruitmentEntity]>(value: [])
    private var pageCount: Int = 1

    init(
        fetchRecruitmentListUseCase: FetchRecruitmentListUseCase,
        bookmarkUseCase: BookmarkUseCase
    ) {
        self.fetchRecruitmentListUseCase = fetchRecruitmentListUseCase
        self.bookmarkUseCase = bookmarkUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let bookMarkButtonDidTap: PublishRelay<Int>
        var pageChange: PublishRelay<Int>
        let cellClicked: PublishRelay<Void>
    }

    public struct Output {
        var recruitmentData = BehaviorRelay<[RecruitmentEntity]>(value: [])
    }

    public func transform(_ input: Input) -> Output {
        input.viewAppear.asObservable()
            .flatMap {
                self.pageCount = 1
                return self.fetchRecruitmentListUseCase.execute(page: self.pageCount)
            }
            .bind(onNext: {
                self.recruitmentData.accept([])
                var currentElements = self.recruitmentData.value
                currentElements.append(contentsOf: $0)
                self.recruitmentData.accept(currentElements)
            })
            .disposed(by: disposeBag)

        input.pageChange.asObservable()
            .flatMap { value in
                if value == self.recruitmentData.value.count-1 {
                    self.pageCount += 1
                    return self.fetchRecruitmentListUseCase.execute(page: self.pageCount)
                } else {
                    return Single.just([])
                }
            }
            .bind(onNext: {
                var currentElements = self.recruitmentData.value
                currentElements.append(contentsOf: $0)
                self.recruitmentData.accept(currentElements)
            })
            .disposed(by: disposeBag)

        input.bookMarkButtonDidTap.asObservable()
            .flatMap { id in
                self.bookmarkUseCase.execute(id: id)
            }.subscribe(onCompleted: {
                print("bookmark!")
            }).disposed(by: disposeBag)

        input.cellClicked.asObservable()
            .map { _ in
                RecruitmentStep.recruitmentDetailIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        return Output(recruitmentData: recruitmentData)
    }
}
