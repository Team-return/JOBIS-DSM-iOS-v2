import ProjectDescription
import ProjectDescriptionHelpers
let dependencies = Dependencies(
    swiftPackageManager: .init([
        .remote(
            url: "https://github.com/SnapKit/SnapKit.git",
            requirement: .upToNextMinor(from: "5.0.0")
        ),
        .remote(
            url: "https://github.com/ReactiveX/RxSwift.git",
            requirement: .upToNextMinor(from: "6.5.0")
        ),
        .remote(
            url: "https://github.com/Quick/Quick.git",
            requirement: .upToNextMajor(from: "6.1.0")
        ),
        .remote(
            url: "https://github.com/Quick/Nimble.git",
            requirement: .upToNextMajor(from: "11.0.0")
        ),
        .remote(
            url: "https://github.com/RxSwiftCommunity/RxFlow.git",
            requirement: .upToNextMajor(from: "2.13.0")
        ),
        .remote(
            url: "https://github.com/devxoul/Then.git",
            requirement: .upToNextMajor(from: "3.0.0")
        ),
        .remote(
            url: "https://github.com/Swinject/Swinject.git",
            requirement: .upToNextMajor(from: "2.8.3")
        )
    ]),
    platforms: [.iOS]
)
