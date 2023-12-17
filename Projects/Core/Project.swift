import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Core",
    product: .framework,
    targets: [.unitTest],
    dependencies: [
        .Modules.thirdPartyLib
    ]
)
