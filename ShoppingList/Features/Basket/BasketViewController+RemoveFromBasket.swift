extension BasketViewController: RemoveFromBasketDelegate {
    func removeItemFromBasket(_ item: Item) {
        guard let itemIndex = Repository.ItemsInBasket.getIndexOf(item) else { return }
        
        Repository.ItemsInBasket.restore(item)
        tableView.deleteRow(at: itemIndex, with: .left)
        refreshScene()
    }
}
