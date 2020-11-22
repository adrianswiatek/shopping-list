//import ShoppingList_Domain
//
//public final class RemoveItemsFromBasketCommand: BasketCommand {
//    public override func execute(at indexPaths: [IndexPath]) {
//        viewController.tableView.deleteRows(at: indexPaths, with: .automatic)
//        repository.remove(items)
//    }
//    
//    public override func undo(at indexPaths: [IndexPath]) {
//        viewController.tableView.insertRows(at: indexPaths, with: .automatic)
//        repository.add(items)
//    }
//}
