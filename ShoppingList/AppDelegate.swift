import ShoppingList_Persistence
import ShoppingList_ViewModels
import ShoppingList_Views
import UIKit

@UIApplicationMain
internal class AppDelegate: UIResponder, UIApplicationDelegate {
    internal var window: UIWindow?

    internal func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UINavigationBar.appearance().isTranslucent = false

        let rootViewController = ListsViewController(viewModel: ListsViewModel())
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        
        return true
    }

    internal func applicationWillTerminate(_ application: UIApplication) {
        Repository.shared.save()
    }
}
