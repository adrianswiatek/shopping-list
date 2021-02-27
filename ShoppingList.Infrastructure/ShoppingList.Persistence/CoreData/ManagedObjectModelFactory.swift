import CoreData

public final class ManagedObjectModelFactory {
    public let modelName: String

    public init(modelName: String) {
        self.modelName = modelName
    }

    public func create() -> NSManagedObjectModel {
        Bundle(for: Self.self)
            .url(forResource: "ShoppingList", withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }!
    }
}
