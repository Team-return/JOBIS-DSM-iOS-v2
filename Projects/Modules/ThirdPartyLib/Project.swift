import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "ThirdPartyLib",
    product: .staticFramework,
    targets: [],
    packages: [.FCM],
    dependencies: [
        .SPM.RxCocoa,
        .SPM.RxFlow,
        .SPM.RxSwift,
        .SPM.SnapKit,
        .SPM.Then,
        .SPM.Swinject,
        .SPM.Moya,
        .SPM.RxMoya,
        .SPM.Lottie,
        .SPM.KeychainSwift,
        .SPM.ReactorKit,
        .SPM.RxGesture,
        .SPM.FCM,
        .SPM.DGCharts,
        .SPM.Pulse,
        .SPM.PulseUI,
        .SPM.Nuke
    ]
)
