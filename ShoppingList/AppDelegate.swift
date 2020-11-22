import ShoppingList_ViewModels
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().isTranslucent = false

        let rootViewController = ListsViewController(viewModel: ListsViewModel())
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        Repository.shared.save()
    }
}
