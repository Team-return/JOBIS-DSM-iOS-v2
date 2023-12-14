import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class MyPageViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    private let fetchStudentInfoUseCase: FetchStudentInfoUseCase
    private let fetchWritableReviewListUseCase: FetchWritableReviewListUseCase

    init(
        fetchStudentInfoUseCase: FetchStudentInfoUseCase,
        fetchWritableReviewListUseCase: FetchWritableReviewListUseCase
    ) {
        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
        self.fetchWritableReviewListUseCase = fetchWritableReviewListUseCase
    }

    private let disposeBag = DisposeBag()

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let reviewNavigate: PublishRelay<Int>
    }

    public struct Output {
        let studentInfo: PublishRelay<StudentInfoEntity>
        let writableReviewList: BehaviorRelay<[WritableReviewCompanyEntity]>
    }

    public func transform(_ input: Input) -> Output {
        let studentInfo = PublishRelay<StudentInfoEntity>()
        let writableReviewList = BehaviorRelay<[WritableReviewCompanyEntity]>(value: [])
        input.viewAppear.asObservable()
            .flatMap { self.fetchStudentInfoUseCase.execute() }
            .bind(to: studentInfo)
            .disposed(by: disposeBag)
        input.viewAppear.asObservable()
            .flatMap { self.fetchWritableReviewListUseCase.execute() }
            .bind(to: writableReviewList)
            .disposed(by: disposeBag)
        input.reviewNavigate.asObservable()
            .subscribe(onNext: {
                // TODO: 리뷰 리스트로 네비게이션 이동 해주는 코드 았어야함
                print($0)
            }).disposed(by: disposeBag)
        return Output(studentInfo: studentInfo,
                      writableReviewList: writableReviewList)
    }
}
