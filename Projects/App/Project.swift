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
    ),
    .init(
        name: env.targetTestName,
        platform: .iOS,
        product: .unitTests,
        bundleId: "\(env.organizationName).\(env.targetName)Tests",
        deploymentTarget: env.deploymentTarget,
        infoPlist: .default,
        sources: ["Tests/**"],
        dependencies: [
            .target(name: env.targetName)
        ]
    )
]
)
