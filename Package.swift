// swift-tools-version: 6.2
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [:],
    baseSettings: .settings(configurations: [
        .debug(name: "DEV"),
        .debug(name: "STAGE"),
        .release(name: "PROD")
    ])
)
#endif

let package = Package(
    name: "JOBIS-DSM-iOS-v2",
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMinor(from: "5.0.0")),
        .package(url: "https://github.com/devxoul/Then.git", from: "3.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMinor(from: "6.5.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxFlow.git", from: "2.13.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.3"),
        .package(url: "https://github.com/team-return/Moya.git", branch: "master"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.3.3"),
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "20.0.0"),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", from: "3.2.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture.git", from: "4.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.3.0"),
        .package(url: "https://github.com/danielgindi/Charts.git", from: "5.1.0"),
        .package(url: "https://github.com/kean/Pulse.git", from: "4.2.0"),
        .package(url: "https://github.com/kean/Nuke.git", from: "12.8.0"),
        .package(url: "https://github.com/Juanpe/SkeletonView.git", from: "1.31.0"),
    ]
)