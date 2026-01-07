import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin
import EnvironmentPlugin
import ConfigurationPlugin
import Foundation

let isCI: Bool = (ProcessInfo.processInfo.environment["TUIST_CI"] ?? "0") == "1"

let configurations: [Configuration] = [
    .debug(name: "DEV", xcconfig: .relativeToXCConfig(type: .dev, name: env.targetName)),
    .debug(name: "STAGE", xcconfig: .relativeToXCConfig(type: .stage, name: env.targetName)),
    .release(name: "PROD", xcconfig: .relativeToXCConfig(type: .prod, name: env.targetName))
]

let settings: Settings = .settings(
    base: env.baseSetting,
    configurations: configurations,
    defaultSettings: .recommended
)

let scripts: [TargetScript] = isCI ? [.googleInfoPlistScripts] : [.swiftLint, .googleInfoPlistScripts]

let targets: [Target] = [
    .target(
        name: env.targetName,
        destinations: [.iPhone, .iPad],
        product: .app,
        bundleId: "$(APP_BUNDLE_ID)",
        deploymentTargets: env.deploymentTarget,
        infoPlist: .file(path: "Support/Info.plist"),
        sources: .sources,
        resources: .resources,
        entitlements: "Support/\(env.appName).entitlements",
        scripts: scripts,
        dependencies: [
            .Projects.flow,
            .SPM.FCM
        ],
        settings: .settings(
            base: env.baseSetting,
            configurations: configurations,
            defaultSettings: .recommended
        )
    ),
    .target(
        name: env.targetTestName,
        destinations: [.iPhone, .iPad],
        product: .unitTests,
        bundleId: "\(env.organizationName).\(env.targetTestName)Tests",
        deploymentTargets: env.deploymentTarget,
        infoPlist: .default,
        sources: .unitTests,
        dependencies: [
            .target(name: env.targetName)
        ],
        settings: settings
    )
]

let schemes: [Scheme] = [
    Scheme.scheme(
      name: "\(env.targetName)-DEV",
      shared: true,
      buildAction: .buildAction(targets: ["\(env.targetName)"]),
      testAction: TestAction.targets(
          ["\(env.targetTestName)"],
          configuration: "DEV",
          options: TestActionOptions.options(
              coverage: true,
              codeCoverageTargets: ["\(env.targetName)"]
          )
      ),
      runAction: RunAction.runAction(configuration: "DEV"),
      archiveAction: ArchiveAction.archiveAction(configuration: "DEV"),
      profileAction: ProfileAction.profileAction(configuration: "DEV"),
      analyzeAction: AnalyzeAction.analyzeAction(configuration: "DEV")
    ),
    Scheme.scheme(
      name: "\(env.targetName)-PROD",
      shared: true,
      buildAction: .buildAction(targets: ["\(env.targetName)"]),
      testAction: nil,
      runAction: RunAction.runAction(configuration: "PROD"),
      archiveAction: ArchiveAction.archiveAction(configuration: "PROD"),
      profileAction: ProfileAction.profileAction(configuration: "PROD"),
      analyzeAction: AnalyzeAction.analyzeAction(configuration: "PROD")
    ),
    Scheme.scheme(
      name: "\(env.targetName)-STAGE",
      shared: true,
      buildAction: .buildAction(targets: ["\(env.targetName)"]),
      testAction: nil,
      runAction: RunAction.runAction(configuration: "STAGE"),
      archiveAction: ArchiveAction.archiveAction(configuration: "STAGE"),
      profileAction: ProfileAction.profileAction(configuration: "STAGE"),
      analyzeAction: AnalyzeAction.analyzeAction(configuration: "STAGE")
    )
]

let project = Project(
    name: env.targetName,
    organizationName: env.organizationName,
    packages: [.FCM],
    settings: settings,
    targets: targets,
    schemes: schemes
)
