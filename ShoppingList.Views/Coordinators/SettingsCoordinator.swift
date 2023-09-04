import ShoppingList_Shared
import ShoppingList_ViewModels

import UIKit
import SwiftUI

public final class SettingsCoordinator: Coordinator {
    public let navigationController: UINavigationController
    public let childCoordinators: [Coordinator]

    public var didDismiss: ((Coordinator) -> Void)?

    private let viewModelsFactory: ViewModelsFactory

    public init(_ viewModelsFactory: ViewModelsFactory) {
        self.viewModelsFactory = viewModelsFactory
        self.navigationController = UINavigationController()
        self.navigationController.modalPresentationStyle = .fullScreen
        self.navigationController.view.backgroundColor = .background
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

    public func openSetting(_ settings: SettingsViewModel.Settings) {
        let viewController: UIViewController

        switch settings {
        case .generalSettings:
            viewController = UIHostingController(
                rootView: GeneralSettingsView(
                    viewModel: viewModelsFactory.generalSettingsViewModel()
                )
            )
            viewController.title = "General Settings"
        case .manageCategories:
            viewController = ManageCategoriesViewController(
                viewModel: viewModelsFactory.manageCategoriesViewModel()
            )
            viewController.title = "Manage Categories"
        case .manageItemsNames:
            viewController = UIHostingController(
                rootView: ManageItemsNamesView(
                    viewModel: viewModelsFactory.manageItemsNamesViewModel()
                )
            )
            viewController.title = "Manage Items Names"
        }

        navigationController.pushViewController(viewController, animated: true)
    }
}
