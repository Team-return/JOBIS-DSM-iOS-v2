import Swinject
import Domain

public struct SettingPresentationAssembly: Assembly {
    public func assemble(container: Container) {

        // ... 기존 등록 코드 ...

        // MARK: - Notice Detail 등록

        // 1. Reactor 등록: argument로 noticeID를 받습니다.
        container.register(NoticeDetailReactor.self) { (resolver: Resolver, noticeID: Int) in
            NoticeDetailReactor(
                noticeID: noticeID,
                fetchNoticeDetailUseCase: resolver.resolve(FetchNoticeDetailUseCase.self)!
            )
        }

        // 2. ViewController 등록: Reactor와 동일하게 argument를 전달합니다.
        container.register(NoticeDetailViewController.self) { (resolver: Resolver, noticeID: Int) in
            NoticeDetailViewController(
                resolver.resolve(NoticeDetailReactor.self, argument: noticeID)!
            )
        }
    }
}
