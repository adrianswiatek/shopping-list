import ShoppingList_Application
import Combine
import CoreData

public final class CoreDataChangeListener {
    private let notificationCenter: NotificationCenter
    private let eventBus: EventBus

    private var cancellables: Set<AnyCancellable>

    public init(notificationCenter: NotificationCenter, eventBus: EventBus) {
        self.notificationCenter = notificationCenter
        self.eventBus = eventBus
        self.cancellables = []
    }

    public func start() {
        let didSaveObjects = notificationCenter
            .publisher(for: NSManagedObjectContext.didSaveObjectsNotification)
            .compactMap { $0.userInfo }
            .share()

        didSaveObjects
            .flatMap { (userInfo: [AnyHashable: Any]) -> AnyPublisher<NSManagedObject, Never> in
                if let inserted: Set<NSManagedObject> = userInfo.value(for: .insertedObjects) {
                    return inserted.publisher.eraseToAnyPublisher()
                }
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] in
                if let list = $0 as? ListEntity {
                    self?.eventBus.send(ListAddedEvent(.fromUuid(list.id!)))
                } else if let item = $0 as? ItemEntity {
                    self?.eventBus.send(ItemAddedEvent(.fromUuid(item.id!)))
                } else if let category = $0 as? CategoryEntity {
                    self?.eventBus.send(ItemsCategoryAddedEvent(.fromUuid(category.id!)))
                } else if let itemsOrder = $0 as? ItemsOrderEntity {
                    self?.eventBus.send(ItemsReorderedEvent(.fromUuid(itemsOrder.listId!)))
                }
            }
            .store(in: &cancellables)

        didSaveObjects
            .flatMap { (userInfo: [AnyHashable: Any]) -> AnyPublisher<NSManagedObject, Never> in
                if let deleted: Set<NSManagedObject> = userInfo.value(for: .deletedObjects) {
                    return deleted.publisher.eraseToAnyPublisher()
                }
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] in
                if let list = $0 as? ListEntity {
                    self?.eventBus.send(ListRemovedEvent(.fromUuid(list.id!)))
                } else if let item = $0 as? ItemEntity {
                    self?.eventBus.send(ItemRemovedEvent(.fromUuid(item.id!)))
                } else if let category = $0 as? CategoryEntity {
                    self?.eventBus.send(ItemsCategoryRemovedEvent(.fromUuid(category.id!)))
                }
            }
            .store(in: &cancellables)

        didSaveObjects
            .flatMap { (userInfo: [AnyHashable: Any]) -> AnyPublisher<NSManagedObject, Never> in
                if let updated: Set<NSManagedObject> = userInfo.value(for: .updatedObjects) {
                    return updated.publisher.eraseToAnyPublisher()
                }
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] in
                if let list = $0 as? ListEntity {
                    self?.eventBus.send(ListUpdatedEvent(.fromUuid(list.id!)))
                } else if let item = $0 as? ItemEntity {
                    self?.eventBus.send(ItemUpdatedEvent(.fromUuid(item.id!)))
                } else if let category = $0 as? CategoryEntity {
                    self?.eventBus.send(ItemsCategoryUpdatedEvent(.fromUuid(category.id!)))
                }
            }
            .store(in: &cancellables)
    }
}

private extension Dictionary where Key == AnyHashable {
    func value<T>(for key: NSManagedObjectContext.NotificationKey) -> T? {
        self[key.rawValue] as? T
    }
}
