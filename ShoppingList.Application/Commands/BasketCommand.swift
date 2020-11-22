//import ShoppingList_Domain
//
//public class BasketCommand: Command {
//    public var source: CommandSource
//    
//    public let items: [Item]
//    public let viewController: BasketViewController
//    public let repository: Repository
//
//    public let itemsIndexPaths: [IndexPath]
//    
//    public init(_ items: [Item], _ viewController: BasketViewController) {
//        self.source = .basket
//        self.items = items
//        self.viewController = viewController
//        self.repository = Repository.shared
//        
//        self.itemsIndexPaths = items
//            .map { item -> Int? in viewController.items.firstIndex { $0.id == item.id } }
//            .compactMap { $0 }
//            .map { IndexPath(row: $0, section: 0) }
//    }
//    
//    public convenience init(_ item: Item, _ viewController: BasketViewController) {
//        self.init([item], viewController)
//    }
//    
//    public func canExecute() -> Bool {
//        return itemsIndexPaths.count > 0
//    }
//    
//    public func execute() {
//        viewController.items.removeAll { items.map { $0.id}.contains($0.id) }
//        execute(at: itemsIndexPaths)
//        
//        repository.setItemsOrder(viewController.items, in: viewController.list, forState: .inBasket)
//        viewController.refreshUserInterface()
//    }
//    
//    public func execute(at indexPaths: [IndexPath]) {}
//    
//    public func undo() {
//        items.reversed().forEach { viewController.items.insert($0, at: 0) }
//        undo(at: (0..<items.count).map { IndexPath(row: $0, section: 0) })
//        repository.setItemsOrder(viewController.items, in: viewController.list, forState: .inBasket)
//        viewController.refreshUserInterface()
//    }
//    
//    public func undo(at indexPaths: [IndexPath]) {}
//}
