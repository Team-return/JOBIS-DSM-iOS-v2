import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Flow",
    product: .staticLibrary,
    targets: [.unitTest],
    packages: [.FCM],
    dependencies: [
        .Projects.data,
        .Projects.presentation,
        .SPM.FCM
    ]
)
