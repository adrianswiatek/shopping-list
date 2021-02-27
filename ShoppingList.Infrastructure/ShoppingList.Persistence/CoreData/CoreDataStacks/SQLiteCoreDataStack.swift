import CoreData

public final class SQLiteCoreDataStack: CoreDataStack {
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: modelFactory.modelName,
            managedObjectModel: modelFactory.create()
        )
        container.loadPersistentStores(completionHandler: {
            guard let error = $1 as NSError? else { return }
            fatalError("Unresolved error \(error), \(error.userInfo)")
        })
        return container
    }()

    private let modelFactory: ManagedObjectModelFactory

    public init(_ modelFactory: ManagedObjectModelFactory) {
        self.modelFactory = modelFactory
    }
}
