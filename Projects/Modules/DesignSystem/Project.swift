import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "DesignSystem",
    product: .framework,
    targets: [.demo],
    dependencies: [
        .Projects.core
    ],
    resources: .resources,
    resourceSynthesizers: .default + [
        .custom(name: "Lottie", parser: .json, extensions: ["json"])
    ]
)
