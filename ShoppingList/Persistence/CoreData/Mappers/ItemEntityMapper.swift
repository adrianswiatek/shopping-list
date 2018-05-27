extension Item {
    func map() -> ItemEntity {
        let entity = ItemEntity()
        entity.id = self.id
        entity.name = self.name
        entity.state = Int32(self.state.rawValue)
        return entity
    }
}

extension ItemEntity {
    func map() -> Item {
        guard
            let id = self.id,
            let name = self.name,
            let state = ItemState(rawValue: Int(self.state))
            else { fatalError("Unable to create Item") }
        
        return Item(id: id, name: name, state: state, category: nil)
    }
}
