import CoreData

extension CategoryEntity {
    func map() -> Category {
        guard let id = self.id, let name = self.name else {
            fatalError("Unable to create Category")
        }
        
        return Category(id: id, name: name)
    }
    
    func update(by category: Category) {
        guard self.id != category.id else {
            fatalError("Unable to update Categories that have different ids.")
        }
        
        self.name = category.name
    }
}

extension Category {
    func map(context: NSManagedObjectContext) -> CategoryEntity {
        let entity = CategoryEntity(context: context)
        entity.id = self.id
        entity.name = self.name
        return entity
    }
}
