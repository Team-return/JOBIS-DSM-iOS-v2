import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Core",
    product: .staticFramework,
    targets: [.unitTest],
    dependencies: [
        .Modules.thirdPartyLib
    ]
)
