import ShoppingList_ViewModels
import UIKit

public final class ItemsCoordinator: Coordinator {
    public let navigationController: UINavigationController
    public private(set) var childCoordinators: [Coordinator]

    public var stop: ((Coordinator) -> Void)?

    private var currentList: ListViewModel!
    private let viewModelsFactory: ViewModelsFactory

    public init(
        _ viewModelsFactory: ViewModelsFactory,
        _ navigationController: UINavigationController = .init()
    ) {
        self.viewModelsFactory = viewModelsFactory
        self.navigationController = navigationController
        self.childCoordinators = []
    }

    public func start() {
        guard let currentList = currentList else {
            preconditionFailure("currentList must be set.")
        }

        let viewController = ItemsViewController(
            viewModel: viewModelsFactory.itemsViewModel(for: currentList)
        )
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

    public func set(_ currentList: ListViewModel) {
        self.currentList = currentList
    }
}

extension ItemsCoordinator: ItemsViewControllerDelegate {
    public func goToBasket() {
        let basketViewController = BasketViewController()
        navigationController.pushViewController(basketViewController, animated: true)
    }

    public func goToEditItem(_ item: ItemViewModel, for list: ListViewModel) {
        let viewModel = viewModelsFactory.editItemViewModel(for: list)
        viewModel.setItem(item)

        let viewController = EditItemViewController(viewModel: viewModel)

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overCurrentContext

        self.navigationController.viewControllers.first?.present(
            navigationController,
            animated: true
        )
    }

    public func goToCreateItem(for list: ListViewModel) {
        let viewController = EditItemViewController(
            viewModel: viewModelsFactory.editItemViewModel(for: list)
        )

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overCurrentContext

        self.navigationController.viewControllers.first?.present(
            navigationController,
            animated: true
        )
    }

    public func didDismiss() {
        stop?(self)
    }
}
