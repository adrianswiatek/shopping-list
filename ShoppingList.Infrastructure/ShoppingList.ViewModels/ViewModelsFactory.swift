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
        case basket
        case createItemFromModel
        case editItem
        case generalSettings
        case items
        case lists
        case manageCategories
        case manageItemsNames
        case settings
    }
}

public extension ViewModelsFactory {
    func basketViewModel(for list: ListViewModel) -> BasketViewModel {
        configure(create(for: .basket) as! BasketViewModel) {
            $0.setList(list)
        }
    }

    func createItemFromModelViewModel(for list: ListViewModel) -> CreateItemFromModelViewModel {
        configure(create(for: .createItemFromModel) as! CreateItemFromModelViewModel) {
            $0.setList(list)
        }
    }

    func editItemViewModel(for list: ListViewModel) -> EditItemViewModel {
        configure(create(for: .editItem) as! EditItemViewModel) {
            $0.setList(list)
        }
    }

    func generalSettingsViewModel() -> GeneralSettingsViewModel {
        create(for: .generalSettings) as! GeneralSettingsViewModel
    }

    func itemsViewModel(for list: ListViewModel) -> ItemsViewModel {
        configure(create(for: .items) as! ItemsViewModel) {
            $0.setList(list)
        }
    }

    func listsViewModel() -> ListsViewModel {
        create(for: .lists) as! ListsViewModel
    }

    func manageCategoriesViewModel() -> ManageCategoriesViewModel {
        create(for: .manageCategories) as! ManageCategoriesViewModel
    }

    func manageItemsNamesViewModel() -> ManageItemsNamesViewModel {
        create(for: .manageItemsNames) as! ManageItemsNamesViewModel
    }

    func settingsViewModel() -> SettingsViewModel {
        create(for: .settings) as! SettingsViewModel
    }
}
