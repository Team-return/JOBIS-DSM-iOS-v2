import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Core",
    product: .staticLibrary,
    dependencies: [
        .Modules.thirdPartyLib
    ]
)
