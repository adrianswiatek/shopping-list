import UIKit

@UIApplicationMain
internal class AppDelegate: UIResponder, UIApplicationDelegate {
    internal var window: UIWindow?
    internal let container: Container = .init()

    internal func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UINavigationBar.appearance().isTranslucent = false

        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = container.resolveRootViewController()

        container.initialize()

        return true
    }
}
