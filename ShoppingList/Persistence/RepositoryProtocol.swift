protocol RepositoryProtocol {
    func getItemsWith(state: ItemState) -> [Item]
    func add(_ item: Item)
    func remove(_ items: [Item])
    func remove(_ item: Item)
    func updateState(of items: [Item], to state: ItemState)
    func updateState(of item: Item, to state: ItemState)
    func setItemsOrder(_ items: [Item], forState state: ItemState)
    func save()
}
