extension ItemsViewController: AddToBasketDelegate {
    func addItemToBasket(_ item: Item) {
        guard let itemIndex = Repository.ItemsToBuy.getIndexOf(item) else { return }
        
        Repository.ItemsToBuy.moveItemToBasket(item)
        tableView.deleteRow(at: itemIndex, with: .right)
        refreshScene()
    }
}
