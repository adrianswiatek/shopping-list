import ShoppingList_ViewModels
import UIKit

public final class SettingsCoordinator: Coordinator {
    public let navigationController: UINavigationController
    public let childCoordinators: [Coordinator]

    public var didDismiss: ((Coordinator) -> Void)?

    private let viewModelsFactory: ViewModelsFactory

    public init(_ viewModelsFactory: ViewModelsFactory) {
        self.viewModelsFactory = viewModelsFactory
        self.navigationController = UINavigationController()
        self.navigationController.modalPresentationStyle = .fullScreen
        self.childCoordinators = []
    }

    public func start() {
        let viewController = SettingsViewController(
            viewModel: viewModelsFactory.settingsViewModel()
        )
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension SettingsCoordinator: SettingsViewControllerDelegate {
    public func close() {
        navigationController.topViewController?.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.didDismiss?(self)
        }
    }

    public func openSetting() {
        let viewController = ManageCategoriesViewController(
            viewModel: viewModelsFactory.manageCategoriesViewModel()
        )
        navigationController.pushViewController(viewController, animated: true)
    }
}
