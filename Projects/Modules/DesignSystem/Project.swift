import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "DesignSystem",
    product: .staticFramework,
    dependencies: [
        .Projects.core
    ], 
    resources: "Resources/**"
)
