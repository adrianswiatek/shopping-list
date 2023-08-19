import SwiftUI

@main
struct ShoppingList_watchOS_Watch_AppApp: App {
    private let viewModelsFactory = {
        let container = Container()
        return ViewModelsFactory(container: container)
    }()

    var body: some Scene {
        WindowGroup {
            HomeView(viewModelsFactory)
        }
    }
}
