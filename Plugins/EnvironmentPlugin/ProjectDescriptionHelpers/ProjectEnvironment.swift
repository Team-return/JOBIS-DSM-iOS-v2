import ProjectDescription

public struct ProjectEnvironment {
    public let appName: String
    public let targetName: String
    public let targetTestName: String
    public let organizationName: String
    public let deploymentTarget: DeploymentTarget
    public let platform: Platform
    public let baseSetting: SettingsDictionary
}

public let env = ProjectEnvironment(
    appName: "JOBIS-DSM-iOS-v2",
    targetName: "JOBIS-DSM-iOS-v2",
    targetTestName: "DSM-JOBISTests",
    organizationName: "com.team.return",
    deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone, .ipad]),
    platform: .iOS,
    baseSetting: ["OTHER_LDFLAGS": .array(["$(inherited)", "-ObjC"])]
)
