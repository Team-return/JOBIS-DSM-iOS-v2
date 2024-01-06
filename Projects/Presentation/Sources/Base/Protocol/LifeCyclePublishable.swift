import RxCocoa

public protocol LifeCyclePublishable {
    var viewDidLoadPublisher: PublishRelay<Void> { get }
    var viewWillAppearPublisher: PublishRelay<Void> { get }
    var viewDidAppearPublisher: PublishRelay<Void> { get }
    var viewWillDisappearPublisher: PublishRelay<Void> { get }
    var viewDidDisappearPublisher: PublishRelay<Void> { get }
}
