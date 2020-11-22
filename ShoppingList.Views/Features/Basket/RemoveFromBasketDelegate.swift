import ShoppingList_Domain

public protocol RemoveFromBasketDelegate: class {
    func removeItemFromBasket(_ item: Item)
}
