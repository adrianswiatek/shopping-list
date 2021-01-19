import ShoppingList_ViewModels

public protocol RemoveFromBasketDelegate: class {
    func removeItemFromBasket(_ item: ItemInBasketViewModel)
}
