import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
        
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

