import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    swiftPackageManager: .init(
        [
            .remote(
                url: "https://github.com/SnapKit/SnapKit.git",
                requirement: .upToNextMinor(from: "5.0.0")
            ),
            .remote(
                url: "https://github.com/devxoul/Then.git",
                requirement: .upToNextMajor(from: "3.0.0")
            ),
            .remote(
                url: "https://github.com/ReactiveX/RxSwift.git",
                requirement: .upToNextMinor(from: "6.5.0")
            ),
            .remote(
                url: "https://github.com/RxSwiftCommunity/RxFlow.git",
                requirement: .upToNextMajor(from: "2.13.0")
            ),
            .remote(
                url: "https://github.com/Swinject/Swinject.git",
                requirement: .upToNextMajor(from: "2.8.3")
            ),
            .remote(
                url: "https://github.com/team-return/Moya.git",
                requirement: .branch("master")
            ),
            .remote(
                url: "https://github.com/airbnb/lottie-ios.git",
                requirement: .upToNextMajor(from: "4.3.3")
            ),
            .remote(
                url: "https://github.com/onevcat/Kingfisher.git",
                requirement: .upToNextMajor(from: "7.0.0")
            ),
            .remote(
                url: "https://github.com/evgenyneu/keychain-swift.git",
                requirement: .upToNextMajor(from: "20.0.0")
            ),
            .remote(
                url: "https://github.com/ReactorKit/ReactorKit.git",
                requirement: .upToNextMajor(from: "3.2.0")
            ),
            .remote(
                url: "https://github.com/RxSwiftCommunity/RxGesture.git",
                requirement: .upToNextMajor(from: "4.0.0")
            ),
            .remote(
                url: "https://github.com/firebase/firebase-ios-sdk.git",
                requirement: .upToNextMajor(from: "10.3.0")
            ),
            .remote(
                url: "https://github.com/danielgindi/Charts.git",
                requirement: .upToNextMajor(from: "5.1.0")
            )

        ],
        baseSettings: .settings(
            configurations: [
                .debug(name: .dev),
                .debug(name: .stage),
                .release(name: .prod)
            ]
        )
    ),
    platforms: [.iOS]
)
