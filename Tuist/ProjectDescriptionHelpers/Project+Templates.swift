import ConfigurationPlugin
import DependencyPlugin
import EnvironmentPlugin
import Foundation
import ProjectDescription

let isCI = (ProcessInfo.processInfo.environment["TUIST_CI"] ?? "0") == "1" ? true : false

public enum ModuleTarget {
    case unitTest
    case demo
}

public extension Project {
    static func makeModule(
        name: String,
        platform: Platform = env.platform,
        product: Product,
        targets: Set<ModuleTarget>,
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList = .sources,
        resources: ResourceFileElements? = nil,
        resourceSynthesizers: [ResourceSynthesizer] = .default + [],
        settings: SettingsDictionary = [:],
        additionalPlistRows: [String: ProjectDescription.Plist.Value] = [:]
    ) -> Project {
        let scripts: [TargetScript] = isCI ? [] : [.swiftLint]

        let configurations: [Configuration] = isCI ?
        [
          .debug(name: .dev, settings: [:]),
          .debug(name: .stage, settings: [:]),
          .release(name: .prod, settings: [:])
        ] :
        [
          .debug(name: .dev, xcconfig: .relativeToXCConfig(type: .dev, name: name)),
          .debug(name: .stage, xcconfig: .relativeToXCConfig(type: .stage, name: name)),
          .release(name: .prod, xcconfig: .relativeToXCConfig(type: .prod, name: name))
        ]

        let settings: Settings = .settings(
            base: env.baseSetting
                .merging(settings),
            configurations: configurations,
            defaultSettings: .recommended
        )
        let destinations: Set<Destination> = platform == .iOS ? [.iPhone, .iPad] : [.mac]

        var allTargets: [Target] = [
            .target(
                name: name,
                destinations: destinations,
                product: product,
                bundleId: "\(env.organizationName).\(name)",
                deploymentTargets: env.deploymentTarget,
                infoPlist: .extendingDefault(with: additionalPlistRows),
                sources: sources,
                resources: resources,
                scripts: scripts,
                dependencies: dependencies
            )
        ]

        if targets.contains(.unitTest) {
            allTargets.append(
                .target(
                    name: "\(name)Tests",
                    destinations: destinations,
                    product: .unitTests,
                    bundleId: "\(env.organizationName).\(name)Tests",
                    deploymentTargets: env.deploymentTarget,
                    infoPlist: .default,
                    sources: .unitTests,
                    scripts: scripts,
                    dependencies: []
                )
            )
        }

        // MARK: - Demo App
        if targets.contains(.demo) {
            let demoDependencies: [TargetDependency] = [.target(name: name)]
            allTargets.append(
                .target(
                    name: "\(name)DemoApp",
                    destinations: destinations,
                    product: .app,
                    bundleId: "\(env.organizationName).\(name)DemoApp",
                    deploymentTargets: env.deploymentTarget,
                    infoPlist: .extendingDefault(with: [
                        "UIMainStoryboardFile": "",
                        "UILaunchStoryboardName": "LaunchScreen",
                        "ENABLE_TESTS": .boolean(true),
                    ]),
                    sources: .demoSources,
                    resources: .demoResources,
                    scripts: scripts,
                    dependencies: demoDependencies
                )
            )
        }

        let schemes: [Scheme] = targets.contains(.demo) ?
        [.makeScheme(target: .dev, name: name), .makeDemoScheme(target: .dev, name: name)] :
        [.makeScheme(target: .dev, name: name)]

        return Project(
            name: name,
            organizationName: env.organizationName,
            packages: packages,
            settings: settings,
            targets: allTargets,
            schemes: schemes,
            resourceSynthesizers: resourceSynthesizers
        )
    }
}

extension Scheme {
    static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
        return Scheme.scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: RunAction.runAction(configuration: target),
            archiveAction: ArchiveAction.archiveAction(configuration: target),
            profileAction: ProfileAction.profileAction(configuration: target),
            analyzeAction: AnalyzeAction.analyzeAction(configuration: target)
        )
    }

    static func makeDemoScheme(target: ConfigurationName, name: String) -> Scheme {
        return Scheme.scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)DemoApp"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)DemoApp"])
            ),
            runAction: RunAction.runAction(configuration: target),
            archiveAction: ArchiveAction.archiveAction(configuration: target),
            profileAction: ProfileAction.profileAction(configuration: target),
            analyzeAction: AnalyzeAction.analyzeAction(configuration: target)
        )
    }
}
