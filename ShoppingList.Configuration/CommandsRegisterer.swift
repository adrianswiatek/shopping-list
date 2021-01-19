import ShoppingList_Application
import Swinject

public final class CommandsRegisterer {
    private let container: Swinject.Container

    public init(_ container: Swinject.Container) {
        self.container = container
    }

    public func register() {
        registerCommandBus()
        registerListCommandHandlers()
        registerItemCommandHandlers()
        registerItemsCategoryCommandHandlers()
    }

    private func registerCommandBus() {
        container.register(CommandBus.self) {
            CommandBus(commandHandlers: [
                // Lists
                $0.resolve(AddListCommandHandler.self)!,
                $0.resolve(ClearBasketOfListCommandHandler.self)!,
                $0.resolve(ClearListCommandHandler.self)!,
                $0.resolve(RemoveListCommandHandler.self)!,
                $0.resolve(UpdateListCommandHandler.self)!,
                $0.resolve(UpdateListsDateCommandHandler.self)!,

                // Items
                $0.resolve(AddItemCommandHandler.self)!,
                $0.resolve(MoveItemsToBasketCommandHandler.self)!,
                $0.resolve(MoveItemsToListCommandHandler.self)!,
                $0.resolve(RemoveItemsFromBasketCommandHandler.self)!,
                $0.resolve(RestoreItemsToBasketCommandHandler.self)!,

                // ItemsCategories
                $0.resolve(AddDefaultItemsCategoryCommandHandler.self)!,
                $0.resolve(AddItemsCategoryCommandHandler.self)!,
                $0.resolve(ReclaimItemsCategoryCommandHandler.self)!,
                $0.resolve(RemoveItemsCategoryCommandHandler.self)!,
                $0.resolve(UpdateItemsCategoryCommandHandler.self)!
            ])
        }.inObjectScope(.container)
    }

    private func registerListCommandHandlers() {
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

        container.register(UpdateListsDateCommandHandler.self) {
            UpdateListsDateCommandHandler($0.resolve(ListRepository.self)!)
        }
    }

    private func registerItemCommandHandlers() {
        container.register(AddItemCommandHandler.self) {
            AddItemCommandHandler($0.resolve(ItemRepository.self)!)
        }

        container.register(MoveItemsToBasketCommandHandler.self) {
            MoveItemsToBasketCommandHandler($0.resolve(ItemRepository.self)!)
        }

        container.register(MoveItemsToListCommandHandler.self) {
            MoveItemsToListCommandHandler($0.resolve(ItemRepository.self)!)
        }

        container.register(RemoveItemsFromBasketCommandHandler.self) {
            RemoveItemsFromBasketCommandHandler($0.resolve(ItemRepository.self)!)
        }

        container.register(RestoreItemsToBasketCommandHandler.self) {
            RestoreItemsToBasketCommandHandler($0.resolve(ItemRepository.self)!)
        }
    }

    private func registerItemsCategoryCommandHandlers() {
        container.register(AddDefaultItemsCategoryCommandHandler.self) {
            AddDefaultItemsCategoryCommandHandler($0.resolve(ItemsCategoryRepository.self)!)
        }

        container.register(AddItemsCategoryCommandHandler.self) {
            AddItemsCategoryCommandHandler($0.resolve(ItemsCategoryRepository.self)!)
        }

        container.register(RemoveItemsCategoryCommandHandler.self) {
            RemoveItemsCategoryCommandHandler(
                $0.resolve(ItemsCategoryRepository.self)!,
                $0.resolve(ItemRepository.self)!
            )
        }

        container.register(ReclaimItemsCategoryCommandHandler.self) {
            ReclaimItemsCategoryCommandHandler(
                $0.resolve(ItemsCategoryRepository.self)!,
                $0.resolve(ItemRepository.self)!
            )
        }

        container.register(UpdateItemsCategoryCommandHandler.self) {
            UpdateItemsCategoryCommandHandler(
                $0.resolve(ItemsCategoryRepository.self)!,
                $0.resolve(LocalPreferences.self)!
            )
        }
    }
}
