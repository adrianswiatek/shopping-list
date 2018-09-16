import Foundation

public class BasketCommand: Command {
    var source: CommandSource
    
    let items: [Item]
    let viewController: BasketViewController
    let repository: Repository
    
    let itemIndices: [Int]
    
    init(_ items: [Item], _ viewController: BasketViewController) {
        self.source = .basket
        self.items = items
        self.viewController = viewController
        self.repository = Repository.shared
        
        self.itemIndices = self.items
            .map { item -> Int? in viewController.items.index { $0.id == item.id } }
            .compactMap { $0 }
    }
    
    func canExecute() -> Bool {
        return itemIndices.count > 0
    }
    
    func execute() {
        viewController.items.removeAll { items.map { $0.id}.contains($0.id) }
        execute(at: itemIndices.map { IndexPath(row: $0, section: 0) })
        
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
