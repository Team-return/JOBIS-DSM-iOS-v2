import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Flow",
    product: .staticLibrary,
    dependencies: [
        .Projects.data,
        .Projects.presentation
    ]
)
