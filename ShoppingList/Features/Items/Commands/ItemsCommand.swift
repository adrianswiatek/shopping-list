import Foundation

class ItemsCommand: Command {
    var source: CommandSource
    
    let item: Item
    let viewController: ItemsViewController
    let repository: Repository
    
    init(_ item: Item, _ viewController: ItemsViewController) {
        self.source = .items
        self.item = item
        self.viewController = viewController
        self.repository = Repository.shared
    }
    
    func execute() {
        guard let section = viewController.categories.index(where: { $0.id == item.getCategory().id }) else {
            fatalError("Unable to find index of the category.")
        }
        
        guard let row = viewController.items[section].index(where: { $0.id == item.id }) else {
            fatalError("Unable to find index of the item.")
        }
        
        execute(at: IndexPath(row: row, section: section))
        
        saveItemsOrder()
        viewController.refreshUserInterface(after: 0.5)
    }
    
    func execute(at indexPath: IndexPath) {}
    
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
        
        undo(at: IndexPath(row: 0, section: categoryIndex ?? 0))
        
        saveItemsOrder()
        viewController.refreshUserInterface(after: 0.5)
    }
    
    func undo(at indexPath: IndexPath) {}
    
    private func getCategoryIndex(_ category: Category) -> Int? {
        return viewController.categories.index { $0.id == item.getCategory().id }
    }
    
    private func saveItemsOrder() {
        let items = viewController.items.flatMap({ $0 })
        repository.setItemsOrder(items, in: viewController.currentList, forState: .toBuy)
    }
}
