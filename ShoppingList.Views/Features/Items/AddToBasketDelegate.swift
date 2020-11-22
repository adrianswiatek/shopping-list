import ShoppingList_Domain

public protocol AddToBasketDelegate: class {
    func addItemToBasket(_ item: Item)
}
