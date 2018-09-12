import Foundation

class RemoveListCommand: Command {
    var source: CommandSource
    
    private let list: List
    private let viewController: ListsViewController
    private let repository: Repository
    
    init(_ list: List, _ viewController: ListsViewController) {
        self.source = .lists
        self.list = list
        self.viewController = viewController
        self.repository = Repository.shared
    }
    
    func execute() {
        guard let index = viewController.lists.index(where: { $0.id == list.id }) else { return }
        
        viewController.lists.remove(at: index)
        viewController.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        
        repository.remove(self.list)
        
        viewController.refreshUserInterface()
    }
    
    func undo() {
        viewController.lists.append(list)
        viewController.lists.sort { $0.updateDate > $1.updateDate }
        
        let index = viewController.lists.index { $0.id == list.id } ?? 0
        viewController.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        
        repository.add(self.list)
        
        viewController.refreshUserInterface()
    }
}
