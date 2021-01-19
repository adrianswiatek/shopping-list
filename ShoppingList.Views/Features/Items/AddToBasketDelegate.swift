import ShoppingList_ViewModels

public protocol AddToBasketDelegate: class {
    func addItemToBasket(_ item: ItemToBuyViewModel)
}
