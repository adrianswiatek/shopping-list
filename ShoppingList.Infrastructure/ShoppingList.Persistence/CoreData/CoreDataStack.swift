import CoreData

public final class CoreDataStack {
    public lazy var persistentContainer: NSPersistentContainer = {
        guard
            let url = bundle.url(forResource: "ShoppingList", withExtension: "momd"),
            let objectModel = NSManagedObjectModel(contentsOf: url)
        else {
            fatalError("Unable to load managed object model.")
        }

        let container = NSPersistentContainer(name: "ShoppingList", managedObjectModel: objectModel)
        container.loadPersistentStores(completionHandler: {
            guard let error = $1 as NSError? else { return }
            fatalError("Unresolved error \(error), \(error.userInfo)")
        })
        return container
    }()

    public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private var bundle: Bundle {
        .init(for: Self.self)
    }

    public init() {}

    public func save() {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            print("Unable to save into Core Data: \((error as NSError).userInfo)")
        }
    }
}
