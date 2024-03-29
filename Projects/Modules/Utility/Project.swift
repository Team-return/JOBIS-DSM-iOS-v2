import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Utility",
    product: .framework,
    targets: [],
    dependencies: [
        .Projects.core
    ]
)
