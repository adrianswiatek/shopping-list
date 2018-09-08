import Foundation

class BasketCommand: Command {
    var source: CommandSource
    
    let item: Item
    let viewController: BasketViewController
    let repository: Repository
    
    init(_ item: Item, _ viewController: BasketViewController) {
        self.source = .basket
        self.item = item
        self.viewController = viewController
        self.repository = Repository.shared
    }
    
    func execute() {
        guard let index = viewController.items.index(where: { $0.id == item.id }) else { return }
        
        execute(at: IndexPath(row: index, section: 0))
        repository.setItemsOrder(viewController.items, in: viewController.list, forState: .inBasket)
        viewController.refreshUserInterface()
    }
    
    func execute(at indexPath: IndexPath) {}
    
    func undo() {
        undo(at: IndexPath(row: 0, section: 0))
        viewController.refreshUserInterface()
    }
    
    func undo(at indexPath: IndexPath) {}
}
