//import UIKit
//import RxSwift
//import RxCocoa
//import RxFlow
//import Core
//import Domain
//
//public final class BugReportListViewModel: BaseViewModel, Stepper {
//    public let steps = PublishRelay<Step>()
//    private let disposeBag = DisposeBag()
//    public var majorType: String = "전체"
//    private let fetchBugListUseCase: FetchBugListUseCase
//
//    init(
//        fetchBugListUseCase: FetchBugListUseCase
//    ) {
//        self.fetchBugListUseCase = fetchBugListUseCase
//    }
//
//    public struct Input {
//        let viewAppear: PublishRelay<Void>
//        let majorViewDidTap: PublishRelay<Void>
//    }
//
//    public struct Output {
//        let majorType: String
////        let bugReportList: PublishRelay<[BugReportEntity]>
//    }
//
//    public func transform(_ input: Input) -> Output {
//        let bugReportList = PublishRelay<[BugReportEntity]>()
//
////        input.viewAppear.asObservable()
////            .flatMap {
////                self.fetchBugListUseCase.execute(developmentArea: .all)
////            }
////            .bind(to: bugReportList)
////            .disposed(by: disposeBag)
//
//        input.majorViewDidTap.asObservable()
//            .map { _ in BugReportListStep.majorBottomSheetIsRequired }
//            .bind(to: steps)
//            .disposed(by: disposeBag)
//
//        return Output(
//            majorType: self.majorType
////            bugReportList: bugReportList
//        )
//    }
//}
