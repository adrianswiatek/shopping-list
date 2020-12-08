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
        case settings
    }
}

public extension ViewModelsFactory {
    func listsViewModel() -> ListsViewModel {
        create(for: .lists) as! ListsViewModel
    }

    func settingsViewModel() -> SettingsViewModel {
        create(for: .settings) as! SettingsViewModel
    }
}
