import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "ThirdPartyLib",
    product: .framework,
    dependencies: [
        .SPM.Nimble,
        .SPM.Quick,
        .SPM.RxCocoa,
        .SPM.RxFlow,
        .SPM.RxSwift,
        .SPM.SnapKit,
        .SPM.Then,
        .SPM.Swinject,
        .SPM.Moya,
        .SPM.RxMoya,
        .SPM.Lottie
    ], sources: []
)
