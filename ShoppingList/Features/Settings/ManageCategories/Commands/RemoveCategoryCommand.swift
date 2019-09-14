import Foundation

final class RemoveCategoryCommand: Command {
    var source: CommandSource
    
    private let category: Category
    private let viewController: ManageCategoriesViewController
    private let repository: Repository
    
    init(_ category: Category, _ viewController: ManageCategoriesViewController) {
        self.source = .categories
        self.category = category
        self.viewController = viewController
        self.repository = Repository.shared
    }
    
    func canExecute() -> Bool {
        return viewController.categories.firstIndex(where: { $0.id == category.id }) != nil
    }
    
    func execute() {
        guard let index = viewController.categories.firstIndex(where: { $0.id == category.id }) else { return }
        
        viewController.categories.remove(at: index)
        viewController.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        repository.remove(category)
        
        viewController.refreshUserInterface()
    }
    
    func undo() {
        viewController.categories.append(category)
        viewController.categories.sort { $0.name < $1.name }
        
        let index = viewController.categories.firstIndex { $0.id == category.id } ?? 0
        viewController.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        
        repository.add(category)
        
        viewController.refreshUserInterface()
    }
}
