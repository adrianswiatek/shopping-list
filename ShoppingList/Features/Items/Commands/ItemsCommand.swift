import Foundation

class ItemsCommand: Command {
    var source: CommandSource
    
    let items: [Item]
    let viewController: ItemsViewController
    let repository: Repository
    
    var indexPathsOfItems: [IndexPath]
    
    init(_ items: [Item], _ viewController: ItemsViewController) {
        self.source = .items
        self.items = items
        self.viewController = viewController
        self.repository = Repository.shared
        
        self.indexPathsOfItems = []
        self.indexPathsOfItems = getIndexPathsOfItems()
    }
    
    convenience init(_ item: Item, _ viewController: ItemsViewController) {
        self.init([item], viewController)
    }
    
    private func getIndexPathsOfItems() -> [IndexPath] {
        var indexPathsOfItems = [IndexPath]()
        
        let groupedItemsByCategory = Dictionary(grouping: items) { $0.getCategory() }
        
        for (category, items) in groupedItemsByCategory {
            guard let indexOfCategory = viewController.categories.index(where: { $0.id == category.id }) else {
                continue
            }
            
            let indexPaths = items
                .map { item -> Int? in viewController.items[indexOfCategory].index { $0.id == item.id } }
                .compactMap { $0 }
                .map { IndexPath(row: $0, section: indexOfCategory) }
            
            guard indexPaths.count > 0 else { continue }
            indexPathsOfItems.append(contentsOf: indexPaths)
        }
        
        return indexPathsOfItems.sorted { $0 > $1 }
    }
    
    func canExecute() -> Bool {
        return indexPathsOfItems.count > 0
    }
    
    func execute() {
        indexPathsOfItems.forEach { viewController.items[$0.section].remove(at: $0.row) }
        execute(at: indexPathsOfItems)
        setItemsOrder()
        viewController.refreshUserInterface(after: 0.5)
    }
    
    func execute(at indexPaths: [IndexPath]) {}
    
    func undo() {
        addItems()
        undo(with: items)
        setItemsOrder()
        viewController.refreshUserInterface()
    }
    
    func undo(with items: [Item]) {}
    
    private func addItems() {
        for item in items.reversed() {
            if !viewController.categories.contains(item.getCategory()) {
                viewController.append(item.getCategory())
            }
            
            let categoryIndex = viewController.getCategoryIndex(item)
            viewController.items[categoryIndex].insert(item, at: 0)
            
            let indexPath = IndexPath(row: 0, section: categoryIndex)
            viewController.tableView.insertRows(at: [indexPath], with: .right)
        }
    }
    
    private func setItemsOrder() {
        let items = viewController.items.flatMap { $0 }
        repository.setItemsOrder(items, in: viewController.currentList, forState: .toBuy)
    }
}
