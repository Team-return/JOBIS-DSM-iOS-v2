import Foundation
import ProjectDescription

public struct ProjectEnvironment {
    public let name: String
    public let organizationName: String
    public let deploymentTarget: DeploymentTarget
    public let platform: Platform
}

public let env = ProjectEnvironment(
    name: "JOBIS-DSM-iOS-v2",
    organizationName: "com.team.return",
    deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone, supportsMacDesignedForIOS: true),
    platform: .iOS
)
