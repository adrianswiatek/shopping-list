import ShoppingList_Shared
import UIKit

public final class ViewModelsFactory {
    private var providers: [Type: () -> ViewModel]

    public init(providers: [Type: () -> ViewModel]) {
        self.providers = providers
    }

    private func create(for type: Type) -> ViewModel {
        guard let viewModel = providers[type]?() else {
            preconditionFailure("Factory for given type has not been registered.")
        }
        return viewModel
    }
}

public extension ViewModelsFactory {
    enum `Type` {
        case lists
        case items
        case manageCategories
        case settings
    }
}

public extension ViewModelsFactory {
    func listsViewModel() -> ListsViewModel {
        create(for: .lists) as! ListsViewModel
    }

    func itemsViewModel(for list: ListViewModel) -> ItemsViewModel {
        configure(create(for: .items) as! ItemsViewModel) {
            $0.setList(list)
        }
    }

    func settingsViewModel() -> SettingsViewModel {
        create(for: .settings) as! SettingsViewModel
    }

    func manageCategoriesViewModel() -> ManageCategoriesViewModel {
        create(for: .manageCategories) as! ManageCategoriesViewModel
    }
}
