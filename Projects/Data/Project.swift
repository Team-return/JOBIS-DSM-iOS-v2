import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Data",
    product: .staticLibrary,
    dependencies: [
        .Projects.domain,
        .Modules.appNetwork
    ]
)
