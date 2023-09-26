import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Data",
    product: .staticFramework,
    dependencies: [
        .Projects.domain,
        .Modules.appNetwork
    ]
)
