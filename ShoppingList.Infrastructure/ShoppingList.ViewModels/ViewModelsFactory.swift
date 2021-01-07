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
        case editItem
        case items
        case lists
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

    func editItemViewModel(for list: ListViewModel) -> EditItemViewModel {
        configure(create(for: .editItem) as! EditItemViewModel) {
            $0.selectList(with: list.name)
        }
    }

    func settingsViewModel() -> SettingsViewModel {
        create(for: .settings) as! SettingsViewModel
    }

    func manageCategoriesViewModel() -> ManageCategoriesViewModel {
        create(for: .manageCategories) as! ManageCategoriesViewModel
    }
}
