import UIKit
import FirebaseMessaging
import Data
import Swinject
import Then
import Presentation
import Domain
import Core
import DesignSystem
import UserNotifications
import Firebase
import Pulse
import Nuke

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    static var container = Container()
    var assembler: Assembler!
    var cacheCleanupTimer: Timer?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        DesignSystemFontFamily.registerAllCustomFonts()

        // Nuke 이미지 캐시 설정
        configureNukeImageCache()

        assembler = Assembler([
            KeychainAssembly(),
            DataSourceAssembly(),
            RepositoryAssembly(),
            UseCaseAssembly(),
            PresentationAssembly()
        ], container: AppDelegate.container)

        // 파이어베이스 설정
        FirebaseApp.configure()
        URLSessionProxyDelegate.enableAutomaticRegistration()

        // 앱 실행 시 사용자에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

        // UNUserNotificationCenterDelegate를 구현한 메서드를 실행시킴
        application.registerForRemoteNotifications()

        // 파이어베이스 Meesaging 설정
        Messaging.messaging().delegate = self

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
    ) {}

    func applicationWillTerminate(_ application: UIApplication) {
        // 앱 종료 시 타이머 정리
        stopCacheCleanupTimer()
    }
}

// MARK: - Nuke Image Cache Configuration
extension AppDelegate {
    private func configureNukeImageCache() {
        guard let diskCache = try? DataCache(name: "com.jobis.imagecache") else {
            return
        }
        diskCache.sizeLimit = 150 * 1024 * 1024
        diskCache.sweepInterval = 60 * 60 * 24

        let imageCache = ImageCache()
        imageCache.ttl = 60 * 5

        // ImagePipeline Configuration 설정
        var configuration = ImagePipeline.Configuration()
        configuration.dataCache = diskCache
        configuration.imageCache = imageCache

        ImagePipeline.shared = ImagePipeline(configuration: configuration)

        // 4분 주기
        startCacheCleanupTimer()
    }

    private func startCacheCleanupTimer() {
        cacheCleanupTimer?.invalidate()
        cacheCleanupTimer = Timer.scheduledTimer(
            withTimeInterval: 240.0,
            repeats: true
        ) { [weak self] _ in
            self?.performCacheCleanup()
        }
    }

    private func stopCacheCleanupTimer() {
        cacheCleanupTimer?.invalidate()
        cacheCleanupTimer = nil
    }

    private func performCacheCleanup() {
        if let dataCache = ImagePipeline.shared.configuration.dataCache as? DataCache {
            dataCache.sweep()
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 백그라운드에서 푸시 알림을 탭했을 때 실행
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print("APNS token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }

    // Foreground(앱 켜진 상태)에서도 알림 오는 설정
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.list, .banner])
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        let token = String(describing: fcmToken)
        print("Firebase registration token: \(token)")

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}
