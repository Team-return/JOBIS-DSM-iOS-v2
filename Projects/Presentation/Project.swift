import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Presentation",
    product: .staticLibrary,
    dependencies: [
        .Projects.domain,
        .Modules.designSystem
    ]
)
