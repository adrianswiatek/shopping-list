import CoreData

public protocol CoreDataStack {
    var persistentContainer: NSPersistentContainer { get }
    var context: NSManagedObjectContext { get }
    func save()
}

extension CoreDataStack {
    public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    public func save() {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            print("Unable to save into Core Data: \((error as NSError).userInfo)")
        }
    }
}
