import ProjectDescription

public extension TargetDependency {
    enum SPM {}
}

public extension TargetDependency.SPM {
    static let RxSwift = TargetDependency.external(name: "RxSwift")
    static let RxCocoa = TargetDependency.external(name: "RxCocoa")
    static let Nimble = TargetDependency.external(name: "Nimble")
    static let Quick = TargetDependency.external(name: "Quick")
    static let SnapKit = TargetDependency.external(name: "SnapKit")
    static let Then = TargetDependency.external(name: "Then")
    static let RxFlow = TargetDependency.external(name: "RxFlow")
    static let Swinject = TargetDependency.external(name: "Swinject")
}
