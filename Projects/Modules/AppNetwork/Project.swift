import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "AppNetwork",
    product: .staticFramework,
    targets: [.unitTest],
    dependencies: [
        .Modules.utility
    ]
)
