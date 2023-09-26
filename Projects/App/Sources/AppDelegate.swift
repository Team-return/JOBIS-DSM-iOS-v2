import UIKit
import Swinject
import Then
import Presentation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var container: Container {
        let container = Container()
        container.register(MainViewModel.self) { _ in
            MainViewModel()
        }
        container.register(MainViewController.self) { resolver in
            return MainViewController(resolver.resolve(MainViewModel.self)!)
        }
        return container
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
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
