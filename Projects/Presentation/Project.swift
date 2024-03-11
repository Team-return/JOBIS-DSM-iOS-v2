import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Presentation",
    product: .staticLibrary,
    targets: [.unitTest],
    packages: [.FCM],
    dependencies: [
        .Projects.domain,
        .Modules.designSystem,
        .SPM.FCM
    ]
)
