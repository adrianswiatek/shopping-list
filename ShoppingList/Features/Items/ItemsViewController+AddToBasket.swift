extension ItemsViewController: AddToBasketDelegate {
    func addItemToBasket(_ item: Item) {
        guard let index = items.index(where: { $0.id == item.id }) else { return }
        
        items.remove(at: index)
        tableView.deleteRow(at: index, with: .right)
        
        Repository.shared.updateState(of: item, to: .inBasket)
        
        refreshScene()
    }
}
