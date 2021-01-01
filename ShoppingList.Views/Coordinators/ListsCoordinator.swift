import ShoppingList_ViewModels
import ShoppingList_Shared
import UIKit

public final class ListsCoordinator: Coordinator {
    public let navigationController: UINavigationController
    public private(set) var childCoordinators: [Coordinator]

    private let viewModelsFactory: ViewModelsFactory

    public init(
        _ viewModelsFactory: ViewModelsFactory,
        _ navigationController: UINavigationController = .init()
    ) {
        self.viewModelsFactory = viewModelsFactory
        self.navigationController = navigationController
        self.navigationController.modalPresentationStyle = .fullScreen
        self.childCoordinators = []
    }

    public func start() {
        let viewController = ListsViewController(
            viewModel: viewModelsFactory.listsViewModel()
        )
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension ListsCoordinator: ListsViewControllerDelegate {
    public func goToSettings() {
        let settingsCoordinator = SettingsCoordinator(viewModelsFactory)
        settingsCoordinator.didDismiss = { [weak self] in
            self?.childCoordinators.remove($0)
        }
        settingsCoordinator.start()

        childCoordinators.append(settingsCoordinator)
        navigationController.present(settingsCoordinator.navigationController, animated: true)
    }

    public func goToItems(from list: ListViewModel) {
        let itemsCoordinator = ItemsCoordinator(viewModelsFactory, navigationController)
        itemsCoordinator.stop = { [weak self] in
            self?.childCoordinators.remove($0)
        }
        itemsCoordinator.set(list)
        itemsCoordinator.start()

        childCoordinators.append(itemsCoordinator)
    }
}
