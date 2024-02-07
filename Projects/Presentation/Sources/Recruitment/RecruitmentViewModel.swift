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
    }

    public struct Output {
        let recruitmentList: PublishRelay<[RecruitmentEntity]>
    }

    public func transform(_ input: Input) -> Output {
        let recruitmentList = PublishRelay<[RecruitmentEntity]>()

        input.viewAppear.asObservable()
            .flatMap {
                return self.fetchRecruitmentListUseCase.execute(page: 1, jobCode: nil, techCode: nil, name: nil)
                return self.fetchRecruitmentListUseCase.execute(page: self.pageCount)
            }
            .bind(to: recruitmentList)
            .disposed(by: disposeBag)

        input.pageChange.asObservable()
            .flatMap { page in
                return self.fetchRecruitmentListUseCase.execute(page: page, jobCode: nil, techCode: nil, name: nil)
                return self.fetchRecruitmentListUseCase.execute(page: self.pageCount)
            }
            .bind(to: recruitmentList)
            .disposed(by: disposeBag)

        input.bookMarkButtonDidTap.asObservable()
            .flatMap { id in
                self.bookmarkUseCase.execute(id: id)
            }.subscribe(onCompleted: {
                print("bookmark!")
            }).disposed(by: disposeBag)

        return Output(recruitmentList: recruitmentList)
    }
}
