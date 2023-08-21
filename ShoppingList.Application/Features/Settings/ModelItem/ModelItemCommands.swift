import ShoppingList_Domain

public protocol ModelItemCommands {
    func addFromItems(_ items: [Item])
    func addFromExistingItems()
}
