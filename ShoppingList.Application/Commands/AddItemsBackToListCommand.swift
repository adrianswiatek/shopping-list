//import ShoppingList_Domain
//
//public final class AddItemsBackToListCommand: BasketCommand {
//    public override func execute(at indexPaths: [IndexPath]) {
//        viewController.tableView.deleteRows(at: indexPaths, with: .left)
//        repository.updateState(of: items, to: .toBuy)
//    }
//    
//    public override func undo(at indexPaths: [IndexPath]) {
//        viewController.tableView.insertRows(at: indexPaths, with: .left)
//        repository.updateState(of: items, to: .inBasket)
//    }
//}
