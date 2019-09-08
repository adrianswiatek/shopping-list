import Foundation

public class BasketCommand: Command {
    var source: CommandSource
    
    let items: [Item]
    let viewController: BasketViewController
    let repository: Repository
    
    let itemsIndexPaths: [IndexPath]
    
    init(_ items: [Item], _ viewController: BasketViewController) {
        self.source = .basket
        self.items = items
        self.viewController = viewController
        self.repository = Repository.shared
        
        self.itemsIndexPaths = items
            .map { item -> Int? in viewController.items.firstIndex { $0.id == item.id } }
            .compactMap { $0 }
            .map { IndexPath(row: $0, section: 0) }
    }
    
    convenience init(_ item: Item, _ viewController: BasketViewController) {
        self.init([item], viewController)
    }
    
    func canExecute() -> Bool {
        return itemsIndexPaths.count > 0
    }
    
    func execute() {
        viewController.items.removeAll { items.map { $0.id}.contains($0.id) }
        execute(at: itemsIndexPaths)
        
        repository.setItemsOrder(viewController.items, in: viewController.list, forState: .inBasket)
        viewController.refreshUserInterface()
    }
    
    func execute(at indexPaths: [IndexPath]) {}
    
    func undo() {
        items.reversed().forEach { viewController.items.insert($0, at: 0) }
        undo(at: (0..<items.count).map { IndexPath(row: $0, section: 0) })
        repository.setItemsOrder(viewController.items, in: viewController.list, forState: .inBasket)
        viewController.refreshUserInterface()
    }
    
    func undo(at indexPaths: [IndexPath]) {}
}
