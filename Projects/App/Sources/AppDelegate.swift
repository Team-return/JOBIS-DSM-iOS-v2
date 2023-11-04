import UIKit
import Data
import Swinject
import Then
import Presentation
import Domain
import Core
import DesignSystem

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var container = Container()
    var assembler: Assembler!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        DesignSystemFontFamily.registerAllCustomFonts()

        assembler = Assembler([
            KeychainAssembly(),
            DataSourceAssembly(),
            RepositoryAssembly(),
            UseCaseAssembly(),
            PresentationAssembly()
        ], container: AppDelegate.container)
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) { }
}
