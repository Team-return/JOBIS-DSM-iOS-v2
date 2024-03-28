import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Presentation",
    product: .staticLibrary,
    targets: [.unitTest],
    dependencies: [
        .Projects.domain,
        .Modules.designSystem
    ]
)
