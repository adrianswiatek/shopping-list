//import ShoppingList_Domain
//
//public final class AddItemsToBasketCommand: ItemsCommand {
//    public override func execute(at indexPaths: [IndexPath]) {
//        viewController.tableView.deleteRows(at: indexPaths, with: .right)
//        repository.updateState(of: items, to: .inBasket)
//    }
//    
//    public override func undo(with items: [Item]) {
//        repository.updateState(of: items, to: .toBuy)
//    }
//}
