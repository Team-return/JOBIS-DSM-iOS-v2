import ProjectDescription

public extension ProjectDescription.Path {
    static func relativeToXCConfig(type: ProjectDeployTarget, name: String) -> Self {
         .relativeToRoot("XCConfig/\(name)/\(type.rawValue).xcconfig")
    }
}
