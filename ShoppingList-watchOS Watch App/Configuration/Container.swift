import CoreData
import Swinject

final class Container {
    private let container: Swinject.Container

    init() {
        container = Swinject.Container()

        registerDependencies()
        initialize()
    }

    func resolve<T>() -> T {
        guard let dependency = container.resolve(T.self) else {
            fatalError("Unable to resolve dependency of type: \(T.self).")
        }
        return dependency
    }

    private func initialize() {
        (resolve() as ConnectivityListener).initialize()
    }

    private func registerDependencies() {
        container.register(ConnectivityGateway.self) {
            ConnectivityGateway(
                connectivity: Connectivity(),
                settingsRepository: $0.resolve(SettingsRepository.self)!
            )
        }
        .inObjectScope(.container)

        container.register(ConnectivityListener.self) {
            ConnectivityListener(
                connectivityGateway: $0.resolve(ConnectivityGateway.self)!,
                listsRepository: $0.resolve(ShoppingListsRepository.self)!,
                itemsRepository: $0.resolve(ShoppingItemsRepository.self)!,
                eventBus: $0.resolve(EventBus.self)!
            )
        }
        .inObjectScope(.container)

        container.register(EventBus.self) { _ in
            EventBus()
        }
        .inObjectScope(.container)

        container.register(NSPersistentContainer.self) { _ in
            let modelName = "ShoppingList-watchOS"

            let model = Bundle(for: Self.self)
                .url(forResource: modelName, withExtension: "momd")
                .flatMap(NSManagedObjectModel.init)!

            let container = NSPersistentContainer(name: modelName, managedObjectModel: model)

            container.loadPersistentStores(completionHandler: {
                if let error = $1 as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })

            return container
        }
        .inObjectScope(.container)

        container.register(SettingsRepository.self) { _ in
            UserDefaultsSettingsRepository(userDefaults: .standard)
        }

        container.register(ShoppingItemsRepository.self) {
            CoreDataShoppingItemsRepository(
                persistenceContainer: $0.resolve(NSPersistentContainer.self)!
            )
        }

        container.register(ShoppingItemsService.self) {
            ShoppingItemsService(
                repository: $0.resolve(ShoppingItemsRepository.self)!
            )
        }

        container.register(ShoppingListsRepository.self) {
            CoreDataShoppingListsRepository(
                persistenceContainer: $0.resolve(NSPersistentContainer.self)!
            )
        }

        container.register(ShoppingListsService.self) {
            ShoppingListsService(
                listsRepository: $0.resolve(ShoppingListsRepository.self)!,
                itemsRepository: $0.resolve(ShoppingItemsRepository.self)!
            )
        }
    }
}
