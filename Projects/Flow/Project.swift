import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Flow",
    product: .staticFramework,
    dependencies: [
        .Projects.data,
        .Projects.presentation
    ]
)
