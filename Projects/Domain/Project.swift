import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Domain",
    product: .staticFramework,
    targets: [.unitTest],
    dependencies: [
        .Modules.utility
    ],
    sources: ["Sources/**", "Documentation/**/*.docc"]
)
