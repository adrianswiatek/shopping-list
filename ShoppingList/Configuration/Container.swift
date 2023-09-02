import ShoppingList_Application
import ShoppingList_Connectivity
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

        CommandsRegisterer(container).register()

        registerCommands()
        registerListeners()
        registerOtherObjects()
        registerQueries()
        registerRepositories()
        registerServices()
        registerViewModels()
    }

    public func resolveRootViewController() -> UIViewController {
        container.resolve(AppCoordinator.self)!.navigationController
    }

    public func resolveTestContainer() -> TestContainer {
        container.resolve(TestContainer.self)!
    }

    public func initialize() {
        container.resolve(CommandBus.self)!.execute(AddDefaultItemsCategoryCommand())
        container.resolve(AppCoordinator.self)!.start()
        container.resolve(UpdateListDateListener.self)!.start()
        container.resolve(UpdateItemsOrderListener.self)!.start()
        container.resolve(ItemAddedToListOrUpdatedListener.self)!.start()
//        container.resolve(ConsoleEventListener.self)!.start()
    }

    private func registerCommands() {
        container.register(ModelItemCommands.self) {
            $0.resolve(ModelItemService.self)!
        }
    }

    private func registerQueries() {
        container.register(ListQueries.self) {
            $0.resolve(ListsService.self)!
        }

        container.register(ItemQueries.self) {
            $0.resolve(ItemsService.self)!
        }

        container.register(ItemsCategoryQueries.self) {
            $0.resolve(ItemsCategoryService.self)!
        }

        container.register(ModelItemQueries.self) {
            $0.resolve(ModelItemService.self)!
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

        container.register(ModelItemRepository.self) {
            CoreDataModelItemRepository($0.resolve(CoreDataStack.self)!)
        }
    }

    private func registerServices() {
        container.register(ListsService.self) {
            ListsService(listRepository: $0.resolve(ListRepository.self)!)
        }

        container.register(ItemsService.self) {
            ItemsService(itemRepository: $0.resolve(ItemRepository.self)!)
        }

        container.register(ItemsCategoryService.self) {
            ItemsCategoryService(
                $0.resolve(ItemsCategoryRepository.self)!,
                $0.resolve(LocalPreferences.self)!
            )
        }

        container.register(ModelItemService.self) {
            ModelItemService(
                $0.resolve(ModelItemRepository.self)!,
                $0.resolve(ItemRepository.self)!
            )
        }
    }

    private func registerListeners() {
        container.register(ConsoleEventListener.self) {
            ConsoleEventListener(eventBus: $0.resolve(EventBus.self)!)
        }.inObjectScope(.container)

        container.register(UpdateListDateListener.self) {
            UpdateListDateListener(
                itemRepository: $0.resolve(ItemRepository.self)!,
                commandBus: $0.resolve(CommandBus.self)!,
                eventBus: $0.resolve(EventBus.self)!
            )
        }.inObjectScope(.container)

        container.register(UpdateItemsOrderListener.self) {
            UpdateItemsOrderListener(
                itemRepository: $0.resolve(ItemRepository.self)!,
                commandBus: $0.resolve(CommandBus.self)!,
                eventBus: $0.resolve(EventBus.self)!
            )
        }.inObjectScope(.container)

        container.register(ItemAddedToListOrUpdatedListener.self) {
            ItemAddedToListOrUpdatedListener(
                modelItemCommands: $0.resolve(ModelItemCommands.self)!,
                modelItemRepository: $0.resolve(ModelItemRepository.self)!,
                itemRepository: $0.resolve(ItemRepository.self)!,
                eventBus: $0.resolve(EventBus.self)!
            )
        }.inObjectScope(.container)
    }

    private func registerViewModels() {
        container.register(BasketViewModel.self) {
            BasketViewModel(
                itemQueries: $0.resolve(ItemQueries.self)!,
                commandBus: $0.resolve(CommandBus.self)!,
                eventBus: $0.resolve(EventBus.self)!
            )
        }

        container.register(CreateItemFromModelViewModel.self) {
            CreateItemFromModelViewModel(
                modelItemQueries: $0.resolve(ModelItemQueries.self)!,
                itemsCategoryQueries: $0.resolve(ItemsCategoryQueries.self)!,
                localPreferences: $0.resolve(LocalPreferences.self)!,
                commandBus: $0.resolve(CommandBus.self)!
            )
        }

        container.register(EditItemViewModel.self) {
            EditItemViewModel(
                listQueries: $0.resolve(ListQueries.self)!,
                categoryQueries: $0.resolve(ItemsCategoryQueries.self)!,
                commandBus: $0.resolve(CommandBus.self)!,
                eventBus: $0.resolve(EventBus.self)!
            )
        }

        container.register(EditModelItemViewModel.self) {
            EditModelItemViewModel(
                commandBus: $0.resolve(CommandBus.self)!,
                eventBus: $0.resolve(EventBus.self)!
            )
        }

        container.register(GeneralSettingsViewModel.self) {
            GeneralSettingsViewModel(
                localPreferences: $0.resolve(LocalPreferences.self)!
            )
        }

        container.register(ItemsViewModel.self) {
            ItemsViewModel(
                itemQueries: $0.resolve(ItemQueries.self)!,
                categoryQuries: $0.resolve(ItemsCategoryQueries.self)!,
                sharedItemsFormatter: $0.resolve(SharedItemsFormatter.self)!,
                commandBus: $0.resolve(CommandBus.self)!,
                eventBus: $0.resolve(EventBus.self)!
            )
        }

        container.register(ListsViewModel.self) {
            ListsViewModel(
                listQueries: $0.resolve(ListQueries.self)!,
                commandBus: $0.resolve(CommandBus.self)!,
                eventBus: $0.resolve(EventBus.self)!
            )
        }

        container.register(ManageCategoriesViewModel.self) {
            ManageCategoriesViewModel(
                categoryQueries: $0.resolve(ItemsCategoryQueries.self)!,
                commandBus: $0.resolve(CommandBus.self)!,
                eventBus: $0.resolve(EventBus.self)!
            )
        }

        container.register(ManageItemsNamesViewModel.self) {
            ManageItemsNamesViewModel(
                modelItemQueries: $0.resolve(ModelItemQueries.self)!,
                commandBus: $0.resolve(CommandBus.self)!,
                eventBus: $0.resolve(EventBus.self)!
            )
        }

        container.register(ManageModelItemsViewModel.self) {
            ManageModelItemsViewModel(
                modelItemQueries: $0.resolve(ModelItemQueries.self)!,
                itemsCategoryQueries: $0.resolve(ItemsCategoryQueries.self)!,
                commandBus: $0.resolve(CommandBus.self)!,
                eventBus: $0.resolve(EventBus.self)!
            )
        }

        container.register(SettingsViewModel.self) { _ in
            SettingsViewModel()
        }
    }

    private func registerOtherObjects() {
        container.register(EventBus.self) { _ in
            EventBus()
        }.inObjectScope(.container)

        container.register(NotificationCenter.self) { _ in
            .default
        }.inObjectScope(.container)

        container.register(CoreDataStack.self) { _ in
            let modelFactory = ManagedObjectModelFactory(modelName: "ShoppingList")
            return CommandLine.arguments.contains("-testing")
                ? InMemoryCoreDataStack(modelFactory)
                : SQLiteCoreDataStack(modelFactory)
        }.inObjectScope(.container)

        container.register(SharedItemsFormatter.self) { _ in
            SharedItemsFormatter()
        }

        container.register(LocalPreferences.self) { _ in
            UserDefaultsAdapter(CommandLine.arguments.contains("-testing") ? .init() : .standard)
        }

        container.register(AppCoordinator.self) {
            AppCoordinator($0.resolve(ViewModelsFactory.self)!)
        }.inObjectScope(.container)

        container.register(ConnectivityService.self) { _ in
            ConnectivityGateway(WatchConnectivity())
        }

        container.register(ViewModelsFactory.self) { resolver in
            ViewModelsFactory(providers: [
                .basket: { resolver.resolve(BasketViewModel.self)! },
                .createItemFromModel: { resolver.resolve(CreateItemFromModelViewModel.self)! },
                .editItem: { resolver.resolve(EditItemViewModel.self)! },
                .editModelItem: { resolver.resolve(EditModelItemViewModel.self)! },
                .generalSettings: { resolver.resolve(GeneralSettingsViewModel.self)! },
                .items: { resolver.resolve(ItemsViewModel.self)! },
                .lists: { resolver.resolve(ListsViewModel.self)! },
                .manageCategories: { resolver.resolve(ManageCategoriesViewModel.self)! },
                .manageItems: { resolver.resolve(ManageModelItemsViewModel.self)! },
                .manageItemsNames: { resolver.resolve(ManageItemsNamesViewModel.self)! },
                .settings: { resolver.resolve(SettingsViewModel.self)! }
            ])
        }

        container.register(TestContainer.self) { _ in
            SwinjectTestContainer(self.container)
        }.inObjectScope(.container)
    }
}
