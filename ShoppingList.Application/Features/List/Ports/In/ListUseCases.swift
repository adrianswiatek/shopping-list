import ShoppingList_Domain

public protocol ListUseCases {
    func addList(with name: String)
    func updateList(with id: UUID, newName name: String)
    func removeList(with id: UUID)

    func clearList(with id: UUID)
    func clearBasketOfList(with id: UUID)
}
