final class InMemoryShoppingItemsRepository: ShoppingItemsRepository {
    private var items: [ShoppingItem] = []

    func add(_ items: [ShoppingItem]) async {
        self.items.append(contentsOf: items)
    }

    func fetch(_ listId: Id<ShoppingList>) async -> [ShoppingItem] {
        items.filter { $0.listId == listId }
    }

    func find(_ itemId: Id<ShoppingItem>) async -> ShoppingItem? {
        items.first { $0.id == itemId }
    }

    func delete(_ itemId: Id<ShoppingItem>) async {
        items.removeAll { $0.id == itemId }
    }

    func delete(_ itemIds: [Id<ShoppingItem>]) async {
        items.removeAll { itemIds.contains($0.id) }
    }

    func delete(_ listId: Id<ShoppingList>) async {
        items.removeAll { $0.listId == listId }
    }

    func update(_ item: ShoppingItem) async {
        let index = items.firstIndex { $0.id == item.id }

        if let index {
            items[index] = item
        }
    }

    func updateState(_ itemId: Id<ShoppingItem>, to state: ShoppingItem.State) async {
        let index = items.firstIndex { $0.id == itemId }

        if let index {
            items[index] = items[index].updating(.state(to: state))
        }
    }
}
