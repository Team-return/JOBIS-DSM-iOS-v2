import RxSwift

extension ObservableType {
    public var avoidDuplication: Observable<Element> {
        throttle(.seconds(1), scheduler: MainScheduler.instance)
    }
}
