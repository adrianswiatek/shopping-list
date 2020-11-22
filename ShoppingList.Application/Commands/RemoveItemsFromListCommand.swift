//import ShoppingList_Domain
//
//public final class RemoveItemsFromListCommand: ItemsCommand {
//    public override func execute(at indexPaths: [IndexPath]) {
//        viewController.tableView.deleteRows(at: indexPaths, with: .automatic)
//        repository.remove(items)
//    }
//    
//    public override func undo(with items: [Item]) {
//        repository.add(items)
//    }
//}
