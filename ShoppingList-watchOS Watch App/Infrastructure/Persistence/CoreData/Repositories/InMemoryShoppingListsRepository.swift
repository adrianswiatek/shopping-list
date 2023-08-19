final class InMemoryShoppingListsRepository: ShoppingListsRepository {
    private var lists: [ShoppingList] = []

    func add(_ list: ShoppingList) async {
        lists.append(list)
    }

    func delete(_ listId: Id<ShoppingList>) async {
        lists.removeAll { $0.id == listId }
    }

    func fetchAll() async -> [ShoppingList] {
        lists
    }

    func find(_ listId: Id<ShoppingList>) async -> ShoppingList? {
        lists.first { $0.id == listId }
    }

    func update(_ list: ShoppingList) async {
        let indexOfListToUpdate = lists.firstIndex { $0.id == list.id}
        guard let indexOfListToUpdate else { return }

        lists[indexOfListToUpdate] = list
    }
}
