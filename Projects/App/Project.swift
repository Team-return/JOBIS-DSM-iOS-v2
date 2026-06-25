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
        ]
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
        ]
    )
]

let schemes: [Scheme] = [
    Scheme.scheme(
      name: "\(env.targetName)-DEV",
      shared: true,
      buildAction: .buildAction(targets: ["\(env.targetName)"]),
      testAction: TestAction.targets(
          ["\(env.targetTestName)"],
          configuration: .dev,
          options: TestActionOptions.options(
              coverage: true,
              codeCoverageTargets: ["\(env.targetName)"]
          )
      ),
      runAction: RunAction.runAction(configuration: .dev),
      archiveAction: ArchiveAction.archiveAction(configuration: .dev),
      profileAction: ProfileAction.profileAction(configuration: .dev),
      analyzeAction: AnalyzeAction.analyzeAction(configuration: .dev)
    ),
    Scheme.scheme(
      name: "\(env.targetName)-PROD",
      shared: true,
      buildAction: .buildAction(targets: ["\(env.targetName)"]),
      testAction: nil,
      runAction: RunAction.runAction(configuration: .prod),
      archiveAction: ArchiveAction.archiveAction(configuration: .prod),
      profileAction: ProfileAction.profileAction(configuration: .prod),
      analyzeAction: AnalyzeAction.analyzeAction(configuration: .prod)
    ),
    Scheme.scheme(
      name: "\(env.targetName)-STAGE",
      shared: true,
      buildAction: .buildAction(targets: ["\(env.targetName)"]),
      testAction: nil,
      runAction: RunAction.runAction(configuration: .stage),
      archiveAction: ArchiveAction.archiveAction(configuration: .stage),
      profileAction: ProfileAction.profileAction(configuration: .stage),
      analyzeAction: AnalyzeAction.analyzeAction(configuration: .stage)
    )
]

let project = Project(
    name: env.targetName,
    organizationName: env.organizationName,
    settings: settings,
    targets: targets,
    schemes: schemes
)
