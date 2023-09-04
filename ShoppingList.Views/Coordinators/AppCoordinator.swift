import ShoppingList_ViewModels
import UIKit

public final class AppCoordinator: Coordinator {
    public let navigationController: UINavigationController
    public private(set) var childCoordinators: [Coordinator]

    private let viewModelsFactory: ViewModelsFactory

    public init(_ viewModelsFactory: ViewModelsFactory) {
        self.viewModelsFactory = viewModelsFactory
        self.navigationController = UINavigationController()
        self.childCoordinators = []
    }

    public func start() {
        let listsCoordinator = ListsCoordinator(viewModelsFactory, navigationController)
        listsCoordinator.start()

        childCoordinators.append(listsCoordinator)
    }
}
