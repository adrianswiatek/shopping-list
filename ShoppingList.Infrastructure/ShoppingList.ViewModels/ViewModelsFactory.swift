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
        case editModelItem
        case items
        case lists
        case manageCategories
        case manageItems
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

    func editModelItemViewModel(for modelItem: ModelItemViewModel) -> EditModelItemViewModel {
        configure(create(for: .editModelItem) as! EditModelItemViewModel) {
            $0.setModelItem(modelItem)
        }
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

    func manageModelItemsViewModel() -> ManageModelItemsViewModel {
        create(for: .manageItems) as! ManageModelItemsViewModel
    }

    func settingsViewModel() -> SettingsViewModel {
        create(for: .settings) as! SettingsViewModel
    }
}
