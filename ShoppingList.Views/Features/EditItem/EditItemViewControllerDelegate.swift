import ShoppingList_Domain

public protocol EditItemViewControllerDelegate {
    func didCreate(_ item: Item)
    func didUpdate(_ previousItem: Item, _ newItem: Item)
}
