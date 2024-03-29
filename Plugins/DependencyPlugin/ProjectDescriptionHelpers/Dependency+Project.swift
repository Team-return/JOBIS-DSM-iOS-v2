import ProjectDescription

public extension TargetDependency {
    struct Projects {}
    struct Modules {}
}

public extension TargetDependency.Projects {
    static let core = TargetDependency.project(
        target: "Core",
        path: .relativeToRoot("Projects/Core")
    )
    static let data = TargetDependency.project(
        target: "Data",
        path: .relativeToRoot("Projects/Data")
    )
    static let domain = TargetDependency.project(
        target: "Domain",
        path: .relativeToRoot("Projects/Domain")
    )
    static let flow = TargetDependency.project(
        target: "Flow",
        path: .relativeToRoot("Projects/Flow")
    )
    static let presentation = TargetDependency.project(
        target: "Presentation",
        path: .relativeToRoot("Projects/Presentation")
    )
}

public extension TargetDependency.Modules {
    static let thirdPartyLib = TargetDependency.project(
        target: "ThirdPartyLib",
        path: .relativeToRoot("Projects/Modules/ThirdPartyLib")
    )
    static let appNetwork = TargetDependency.project(
        target: "AppNetwork",
        path: .relativeToRoot("Projects/Modules/AppNetwork")
    )
    static let designSystem = TargetDependency.project(
        target: "DesignSystem",
        path: .relativeToRoot("Projects/Modules/DesignSystem")
    )
    static let utility = TargetDependency.project(
        target: "Utility",
        path: .relativeToRoot("Projects/Modules/Utility")
    )
}
