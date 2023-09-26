import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "JOBIS-DSM-iOS-v2",
    platform: .iOS,
    product: .app,
    dependencies: [
        .Projects.flow
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Support/Info.plist")
)
