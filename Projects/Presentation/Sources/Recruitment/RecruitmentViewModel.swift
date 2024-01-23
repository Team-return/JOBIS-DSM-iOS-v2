import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class RecruitmentViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    private let disposeBag = DisposeBag()

    private let fetchRecruitmentListUseCase: FetchRecruitmentListUseCase
    private let bookmarkUseCase: BookmarkUseCase

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
    }

    public struct Output {
        let recruitmentList: PublishRelay<[RecruitmentEntity]>
        let bookmarkOk: PublishRelay<Void>
    }

    public func transform(_ input: Input) -> Output {
        let recruitmentList = PublishRelay<[RecruitmentEntity]>()
        let bookmarkOk = PublishRelay<Void>()

        input.viewAppear.asObservable()
            .flatMap { self.fetchRecruitmentListUseCase.execute(page: 1, jobCode: nil, techCode: nil, name: nil) }
            .bind(to: recruitmentList)
            .disposed(by: disposeBag)
        input.bookMarkButtonDidTap.asObservable()
            .flatMap { id in
                self.bookmarkUseCase.execute(id: id)
            }.subscribe(onCompleted: {
                print("bookmark!")
            }).disposed(by: disposeBag)
        return Output(recruitmentList: recruitmentList, bookmarkOk: bookmarkOk)
    }
}
