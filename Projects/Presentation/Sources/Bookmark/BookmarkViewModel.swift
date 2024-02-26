import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class BookmarkViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchBookmarkListUseCase: FetchBookmarkListUseCase
    private let bookmarkUseCase: BookmarkUseCase

    init(
        fetchBookmarkListUseCase: FetchBookmarkListUseCase,
        bookmarkUseCase: BookmarkUseCase
    ) {
        self.fetchBookmarkListUseCase = fetchBookmarkListUseCase
        self.bookmarkUseCase = bookmarkUseCase
    }

    public struct Input {
        let viewWillAppear: PublishRelay<Void>
        let removeBookmark: PublishRelay<Int>
    }

    public struct Output {
        let bookmarkList: BehaviorRelay<[BookmarkEntity]>
    }

    public func transform(_ input: Input) -> Output {
        let bookmarkList = BehaviorRelay<[BookmarkEntity]>(value: [])

        input.viewWillAppear.asObservable()
            .flatMap {
                self.fetchBookmarkListUseCase.execute()
            }
            .bind(to: bookmarkList)
            .disposed(by: disposeBag)

        input.removeBookmark.asObservable()
            .flatMap {
                self.bookmarkUseCase.execute(id: $0)
                    .do(onCompleted: {
                        input.viewWillAppear.accept(())
                    })
            }
            .subscribe(onCompleted: .none)
            .disposed(by: disposeBag)

        return Output(bookmarkList: bookmarkList)
    }
}
