import ShoppingList_Domain

public struct RemoveListCommand: Command {
    public let list: List
    public let source: CommandSource

    public init(_ list: List) {
        self.list = list
        self.source = .lists
    }

    public func reversed() -> Command? {
        AddListCommand(list.name)
    }
}

//public final class RemoveListCommand: Command {
//    public private(set) var source: CommandSource
//
//    private let list: List
//    private let viewController: ListsViewController
//    private let repository: Repository
//
//    private let indexOfList: Int?
//
//    init(_ list: List, _ viewController: ListsViewController) {
//        self.source = .lists
//        self.list = list
//        self.viewController = viewController
//        self.repository = Repository.shared
//
//        self.indexOfList = viewController.lists.firstIndex { $0.id == list.id }
//    }
//
//    public func canExecute() -> Bool {
//        indexOfList != nil
//    }
//
//    public func execute() {
//        guard let index = indexOfList else { return }
//
//        viewController.lists.remove(at: index)
//        viewController.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
//
//        repository.remove(list)
//
//        viewController.refreshUserInterface()
//    }
//
//    public func undo() {
//        viewController.lists.append(list)
//        viewController.lists.sort { $0.updateDate > $1.updateDate }
//
//        let index = viewController.lists.firstIndex { $0.id == list.id } ?? 0
//        viewController.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
//
//        repository.add(list)
//
//        viewController.refreshUserInterface()
//    }
//}
