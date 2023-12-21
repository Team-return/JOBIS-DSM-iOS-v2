import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Data",
    product: .staticFramework,
    targets: [.unitTest],
    dependencies: [
        .Projects.domain,
        .Modules.appNetwork
    ]
)
