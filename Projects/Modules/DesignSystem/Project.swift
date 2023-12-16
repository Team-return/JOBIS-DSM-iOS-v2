import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "DesignSystem",
    product: .framework,
    dependencies: [
        .Projects.core
    ],
    resources: "Resources/**"
)
