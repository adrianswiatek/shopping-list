import ShoppingList_Configuration
import UIKit

@UIApplicationMain
internal class AppDelegate: UIResponder, UIApplicationDelegate {
    internal var window: UIWindow?

    internal func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UINavigationBar.appearance().isTranslucent = false
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = Configurator().rootViewController()
        
        return true
    }

    internal func applicationWillTerminate(_ application: UIApplication) {
//        Repository.shared.save()
    }
}
