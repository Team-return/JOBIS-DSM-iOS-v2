import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Domain",
    product: .staticFramework,
    targets: [.unitTest],
    dependencies: [
        .Projects.core
    ]
)
