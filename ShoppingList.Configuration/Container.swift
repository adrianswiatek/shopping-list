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

        registerCommandHandlers()
        registerQueries()
        registerRepositories()
        registerViewModels()
        registerOtherObjects()
    }

    public func startDisplaying() {
        container.resolve(AppCoordinator.self)!.start()
    }

    public func resolveRootViewController() -> UIViewController {
        container.resolve(AppCoordinator.self)!.navigationController
    }

    private func registerCommandHandlers() {
        container.register(AddListCommandHandler.self) {
            AddListCommandHandler($0.resolve(ListRepository.self)!, .init())
        }

        container.register(ClearBasketOfListCommandHandler.self) {
            ClearBasketOfListCommandHandler($0.resolve(ListRepository.self)!, $0.resolve(ItemRepository.self)!)
        }

        container.register(ClearListCommandHandler.self) {
            ClearListCommandHandler($0.resolve(ListRepository.self)!, $0.resolve(ItemRepository.self)!)
        }

        container.register(RemoveListCommandHandler.self) {
            RemoveListCommandHandler($0.resolve(ListRepository.self)!)
        }

        container.register(UpdateListCommandHandler.self) {
            UpdateListCommandHandler($0.resolve(ListRepository.self)!)
        }
    }

    private func registerQueries() {
        container.register(ListQueries.self) {
            $0.resolve(ListsService.self)!
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
                commandBus: $0.resolve(CommandBus.self)!
            )
        }

        container.register(SettingsViewModel.self) { _ in
            SettingsViewModel()
        }
    }

    private func registerOtherObjects() {
        container.register(CommandBus.self) {
            CommandBus(commandHandlers: [
                $0.resolve(AddListCommandHandler.self)!,
                $0.resolve(ClearBasketOfListCommandHandler.self)!,
                $0.resolve(ClearListCommandHandler.self)!,
                $0.resolve(RemoveListCommandHandler.self)!,
                $0.resolve(UpdateListCommandHandler.self)!
            ])
        }.inObjectScope(.container)

        container.register(ListsService.self) {
            ListsService(listRepository: $0.resolve(ListRepository.self)!)
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
