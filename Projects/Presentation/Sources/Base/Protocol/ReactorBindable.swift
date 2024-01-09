import ReactorKit
public protocol ReactorBindable {
    func bindAction()
    func bindState()
}

extension ReactorBindable {
    func bindAction() {}
    func bindState() {}
}
