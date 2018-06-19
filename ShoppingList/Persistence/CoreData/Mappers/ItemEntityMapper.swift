import CoreData

extension ItemEntity {
    func map() -> Item {
        guard
            let id = self.id,
            let name = self.name,
            let state = ItemState(rawValue: Int(self.state))
            else { fatalError("Unable to create Item") }
        
        let category = self.category?.map()
        return Item(id: id, name: name, state: state, category: category)
    }
}

extension Item {
    func map(context: NSManagedObjectContext) -> ItemEntity {
        let entity = ItemEntity(context: context)
        entity.id = self.id
        entity.name = self.name
        entity.state = Int32(self.state.rawValue)
        
        if let categoryId = self.category?.id {
            entity.category = getCategoryEntity(withId: categoryId, context: context)
        }
        
        return entity
    }
    
    private func getCategoryEntity(withId id: UUID, context: NSManagedObjectContext) -> CategoryEntity? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Unable to fetch Category")
        }
    }
}
