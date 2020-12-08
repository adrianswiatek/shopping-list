import ShoppingList_Application
import ShoppingList_Domain
import ShoppingList_ViewModels
import ShoppingList_Views
import ShoppingList_Persistence

import Swinject
import UIKit

public final class Container {
    private let container: Swinject.Container

    public init() {
        container = .init()

        registerQueries()
        registerUseCases()
        registerRepositories()
        registerViewModels()
        registerOtherObjects()
    }

    public func startDisplaying() {
        container.resolve(AppCoordinator.self)?.start()
    }

    public func resolveRootViewController() -> UIViewController {
        container.resolve(AppCoordinator.self)!.navigationController
    }

    private func registerQueries() {
        container.register(ListQueries.self) {
            $0.resolve(ListService.self)!
        }
    }

    private func registerUseCases() {
        container.register(ListUseCases.self) {
            $0.resolve(ListService.self)!
        }
    }

    private func registerRepositories() {
        container.register(ListRepository.self) { _ in
            Repository.shared
        }

        container.register(ItemRepository.self) { _ in
            Repository.shared
        }
    }

    private func registerViewModels() {
        container.register(ListsViewModel.self) {
            ListsViewModel(
                listQueries: $0.resolve(ListQueries.self)!,
                listUseCases: $0.resolve(ListUseCases.self)!,
                commandInvoker: $0.resolve(CommandInvoker.self)!
            )
        }

        container.register(SettingsViewModel.self) { _ in
            SettingsViewModel()
        }
    }

    private func registerOtherObjects() {
        container.register(CommandInvoker.self) { _ in
            InMemoryCommandInvoker(commandHandlers: [
                AddListCommandHandler(Repository.shared),
                RemoveListCommandHandler(Repository.shared)
            ])
        }.inObjectScope(.container)

        container.register(ListService.self) {
            ListService(
                listRepository: $0.resolve(ListRepository.self)!,
                itemRepository: $0.resolve(ItemRepository.self)!,
                listNameGenerator: .init()
            )
        }

        container.register(AppCoordinator.self) {
            AppCoordinator($0.resolve(ViewModelsFactory.self)!)
        }.inObjectScope(.container)

        container.register(ViewModelsFactory.self) { resolver in
            ViewModelsFactory(providers: [
                .lists: { resolver.resolve(ListsViewModel.self)! },
                .settings: { resolver.resolve(SettingsViewModel.self)! }
            ])
        }
    }
}
