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
            ClearBasketOfListCommandHandler($0.resolve(ItemRepository.self)!)
        }

        container.register(ClearListCommandHandler.self) {
            ClearListCommandHandler($0.resolve(ItemRepository.self)!)
        }

        container.register(RemoveListCommandHandler.self) {
            RemoveListCommandHandler($0.resolve(ListRepository.self)!)
        }

        container.register(UpdateListCommandHandler.self) {
            UpdateListCommandHandler($0.resolve(ListRepository.self)!)
        }

        container.register(AddItemsCategoryCommandHandler.self) {
            AddItemsCategoryCommandHandler($0.resolve(ItemsCategoryRepository.self)!)
        }

        container.register(RemoveItemsCategoryCommandHandler.self) {
            RemoveItemsCategoryCommandHandler($0.resolve(ItemsCategoryRepository.self)!)
        }
    }

    private func registerQueries() {
        container.register(ListQueries.self) {
            $0.resolve(ListsService.self)!
        }

        container.register(ItemsCategoryQueries.self) {
            $0.resolve(ItemsCategoryService.self)!
        }
    }

    private func registerRepositories() {
        container.register(ListRepository.self) {
            CoreDataListRepository($0.resolve(CoreDataStack.self)!)
        }

        container.register(ItemsCategoryRepository.self) {
            CoreDataItemsCategoryRepository($0.resolve(CoreDataStack.self)!)
        }

        container.register(ItemRepository.self) {
            CoreDataItemRepository($0.resolve(CoreDataStack.self)!)
        }
    }

    private func registerViewModels() {
        container.register(ListsViewModel.self) {
            ListsViewModel(
                listQueries: $0.resolve(ListQueries.self)!,
                commandBus: $0.resolve(CommandBus.self)!
            )
        }

        container.register(ManageCategoriesViewModel.self) {
            ManageCategoriesViewModel(
                categoryQueries: $0.resolve(ItemsCategoryQueries.self)!,
                itemRepository: $0.resolve(ItemRepository.self)!,
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
                // Lists
                $0.resolve(AddListCommandHandler.self)!,
                $0.resolve(ClearBasketOfListCommandHandler.self)!,
                $0.resolve(ClearListCommandHandler.self)!,
                $0.resolve(RemoveListCommandHandler.self)!,
                $0.resolve(UpdateListCommandHandler.self)!,

                // ItemsCategories
                $0.resolve(AddItemsCategoryCommandHandler.self)!,
                $0.resolve(RemoveItemsCategoryCommandHandler.self)!
            ])
        }.inObjectScope(.container)

        container.register(CoreDataStack.self) { _ in
            CoreDataStack()
        }.inObjectScope(.container)

        container.register(ListsService.self) {
            ListsService(listRepository: $0.resolve(ListRepository.self)!)
        }

        container.register(ItemsCategoryService.self) {
            ItemsCategoryService($0.resolve(ItemsCategoryRepository.self)!)
        }

        container.register(AppCoordinator.self) {
            AppCoordinator($0.resolve(ViewModelsFactory.self)!)
        }.inObjectScope(.container)

        container.register(ViewModelsFactory.self) { resolver in
            ViewModelsFactory(providers: [
                .lists: { resolver.resolve(ListsViewModel.self)! },
                .manageCategories: { resolver.resolve(ManageCategoriesViewModel.self)! },
                .settings: { resolver.resolve(SettingsViewModel.self)! }
            ])
        }
    }
}
