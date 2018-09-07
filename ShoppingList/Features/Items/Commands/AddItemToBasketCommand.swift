import Foundation

class AddItemToBasketCommand: Command {
    let source: CommandSource
    
    private let item: Item
    private let viewController: ItemsViewController
    private let repository: Repository
    
    init(_ item: Item, _ viewController: ItemsViewController) {
        self.item = item
        self.viewController = viewController
        self.source = .items
        self.repository = Repository.shared
    }
    
    func execute() {
        guard let section = viewController.categories.index(where: { $0.id == item.getCategory().id }) else {
            fatalError("Unable to find index of the category.")
        }
        
        guard let row = viewController.items[section].index(where: { $0.id == item.id }) else {
            fatalError("Unable to find index of the item.")
        }
        
        viewController.items[section].remove(at: row)
        viewController.tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .right)
        repository.updateState(of: item, to: .inBasket)
        saveItemsOrder()
        viewController.refreshUserInterface()
    }
    
    func undo() {
        let category = item.getCategory()
        
        var categoryIndex = getCategoryIndex(category)
        if categoryIndex == nil {
            viewController.categories.append(category)
            viewController.categories.sort { $0.name < $1.name }
            
            categoryIndex = getCategoryIndex(category)
            viewController.items.insert([Item](), at: categoryIndex ?? 0)
            viewController.tableView.insertSections(IndexSet(integer: categoryIndex ?? 0), with: .automatic)
        }
        
        viewController.items[0].insert(item, at: 0)
        viewController.tableView.insertRows(at: [IndexPath(row: 0, section: categoryIndex ?? 0)], with: .right)
        repository.updateState(of: item, to: .toBuy)
        saveItemsOrder()
        viewController.refreshUserInterface()
    }
    
    private func getCategoryIndex(_ category: Category) -> Int? {
        return viewController.categories.index { $0.id == item.getCategory().id }
    }
    
    private func saveItemsOrder() {
        let items = viewController.items.flatMap({ $0 })
        repository.setItemsOrder(items, in: viewController.currentList, forState: .toBuy)
    }
}
