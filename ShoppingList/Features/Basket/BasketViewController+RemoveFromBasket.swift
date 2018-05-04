extension BasketViewController: RemoveFromBasketDelegate {
    func removeItemFromBasket(_ item: Item) {
        guard let index = items.index(where: { $0.id == item.id }) else { return }
        
        items.remove(at: index)
        tableView.deleteRow(at: index, with: .left)
        
        Repository.shared.updateState(of: item, to: .toBuy)
        
        refreshScene()
    }
}
