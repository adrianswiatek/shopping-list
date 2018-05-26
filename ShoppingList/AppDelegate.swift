import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .white
        
        let itemsViewController = ItemsViewController()
        let navigationController = UINavigationController(rootViewController: itemsViewController)
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        Repository.shared.save()
    }
}

