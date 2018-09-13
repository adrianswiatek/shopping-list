import Foundation

public class BasketForAllCommand: Command {
    var source: CommandSource
    
    let items: [Item]
    let viewController: BasketViewController
    let repository: Repository
    
    init(_ items: [Item], _ viewController: BasketViewController) {
        self.source = .basket
        self.items = items
        self.viewController = viewController
        self.repository = Repository.shared
    }
    
    func execute() {
        viewController.items.removeAll()
        execute(at: (0..<items.count).map { IndexPath(row: $0, section: 0) })
        repository.setItemsOrder(items, in: viewController.list, forState: .inBasket)
        viewController.refreshUserInterface()
    }
    
    func execute(at indexPaths: [IndexPath]) {}
    
    func undo() {
        viewController.items.append(contentsOf: items)
        undo(at: (0..<items.count).map { IndexPath(row: $0, section: 0) })
        repository.setItemsOrder(items, in: viewController.list, forState: .inBasket)
        viewController.refreshUserInterface()
    }
    
    func undo(at indexPaths: [IndexPath]) {}
}
