import ProjectDescription
import Foundation
import EnvironmentPlugin

let isCI = (ProcessInfo.processInfo.environment["TUIST_CI"] ?? "0") == "1" ? true : false

extension Project {
    public static func makeModule(
        name: String,
        platform: Platform = .iOS,
        product: Product,
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        infoPlist: InfoPlist = .default,
        resourceSynthesizers: [ResourceSynthesizer] = .default
    ) -> Project {
        return project(
            name: name,
            platform: platform,
            product: product,
            packages: packages,
            dependencies: dependencies,
            sources: sources,
            resources: resources,
            infoPlist: infoPlist,
            resourceSynthesizers: resourceSynthesizers
        )
    }
}

public extension Project {
    static func project(
        name: String,
        platform: Platform,
        product: Product,
        organizationName: String = env.organizationName,
        packages: [Package],
        deploymentTarget: DeploymentTarget? = env.deploymentTarget,
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList,
        resources: ResourceFileElements? = nil,
        infoPlist: InfoPlist = .default,
        resourceSynthesizers: [ResourceSynthesizer] = .default
    ) -> Project {
        let scripts: [TargetScript] = isCI ? [] : [.swiftLint]
        let appTarget = Target(
            name: name,
            platform: platform,
            product: product,
            bundleId: "com.team.return.JOBIS-DSM-iOS",
            deploymentTarget: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources, 
            resources: resources, 
            scripts: scripts,
            dependencies: dependencies
        )
        
        return Project(
            name: name,
            organizationName: organizationName,
            packages: packages,
            targets: [appTarget],
            resourceSynthesizers: resourceSynthesizers
        )
    }
}
