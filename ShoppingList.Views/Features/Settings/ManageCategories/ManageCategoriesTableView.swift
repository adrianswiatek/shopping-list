import ShoppingList_ViewModels
import Combine
import UIKit

public final class ManageCategoriesTableView: UITableView {
    public var onAction: AnyPublisher<Action, Never> {
        onActionSubject.eraseToAnyPublisher()
    }

    private let onActionSubject: PassthroughSubject<Action, Never>

    public override init(frame: CGRect, style: UITableView.Style) {
        self.onActionSubject = .init()
        super.init(frame: frame, style: style)
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not available.")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .background
        allowsSelection = false
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 60
        tableFooterView = UIView()
        delegate = self

        register(ManageCategoriesTableViewCell.self, forCellReuseIdentifier: ManageCategoriesTableViewCell.identifier)
    }
}

extension ManageCategoriesTableView: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        .init(identifier: "ManageCategoriesContextMenu" as NSCopying, previewProvider: nil) { [weak self] _ in
            let actions: [UIAction] = [
                self?.editActionForCategory(at: indexPath.row),
                self?.removeActionForCategory(at: indexPath.row)
            ].compactMap { $0 }

            return UIMenu(title: "", children: actions)
        }
    }

    private func editActionForCategory(at index: Int) -> UIAction? {
        guard let category = categoryForCell(at: index) else { return nil }
        return UIAction(title: "Edit category", image: UIImage(systemName: "pencil"), attributes: []) { [weak self] _ in
            self?.onActionSubject.send(.editCategory(id: category.id, name: category.name))
        }
    }

    private func removeActionForCategory(at index: Int) -> UIAction? {
        guard let category = categoryForCell(at: index) else { return nil }
        let image = UIImage(systemName: "trash.fill")
        return UIAction(title: "Remove category", image: image, attributes: .destructive) { [weak self] _ in
            self?.onActionSubject.send(.removeCategory(id: category.id))
        }
    }

    private func categoryForCell(at index: Int) -> ItemsCategoryViewModel? {
        cellForRow(at: .init(row: index, section: 0)).flatMap { $0 as? ManageCategoriesTableViewCell }?.viewModel
    }

//    public func tableView(
//        _ tableView: UITableView,
//        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
//    ) -> UISwipeActionsConfiguration? {
//        let builder = EditContextualActionBuilder(
//            viewController: self,
//            category: categories[indexPath.row],
//            categories: categories,
//            saved: { self.categoryEdited(to: $0, at: indexPath) },
//            savedDefault: { self.defaultCategoryNameChanged(to: $0, at: indexPath) }
//        )
//
//        return UISwipeActionsConfiguration(actions: [builder.build()])
//    }

//    private func defaultCategoryNameChanged(to name: String, at indexPath: IndexPath) {
//        let updatedCategory = updateCategory(to: name, at: indexPath)
//        updateTableViewAfterCategoryUpdate(currentIndexPath: indexPath, category: updatedCategory)
        // Todo: repository
        // Repository.shared.defaultCategoryName = updatedCategory.name
//    }

//    private func categoryEdited(to name: String, at indexPath: IndexPath) {
//        let updatedCategory = updateCategory(to: name, at: indexPath)
//        updateTableViewAfterCategoryUpdate(currentIndexPath: indexPath, category: updatedCategory)
        // Todo: repository
        // Repository.shared.update(updatedCategory)
//    }

//    private func updateCategory(to name: String, at indexPath: IndexPath) -> ItemsCategory {
//        let existingCategory = categories[indexPath.row]
//        let newCategory = existingCategory.withName(name)
//        categories[indexPath.row] = newCategory
//        categories.sort { $0.name < $1.name }
//        return newCategory
//    }

//    private func updateTableViewAfterCategoryUpdate(currentIndexPath: IndexPath, category: ItemsCategory) {
//        guard let newCategoryIndex = categories.firstIndex(where: { $0.id == category.id }) else { return }
//
//        let newIndexPath = IndexPath(row: newCategoryIndex, section: 0)
//        if newIndexPath != currentIndexPath {
//            tableView.moveRow(at: currentIndexPath, to: newIndexPath)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) { [unowned self] in
//            self.tableView.reloadRows(at: [newIndexPath], with: .automatic)
//        }
//    }

//    public func tableView(
//        _ tableView: UITableView,
//        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
//    ) -> UISwipeActionsConfiguration? {
//        let category = categories[indexPath.row]
//
//        let builder = DeleteContextualActionBuilder(
//            viewController: self,
//            category: category,
//            isCategoryEmpty: items.filter { $0.category.id == category.id }.count == 0,
//            deleteCategory: { self.deleteCategory(at: indexPath) },
//            deletedCategoryWithItems: deletedCategoryWithItems)
//        return UISwipeActionsConfiguration(actions: [builder.build()])
//    }

//    private func deleteCategory(at indexPath: IndexPath) {
        //        let category = categories.remove(at: indexPath.row)
//        deleteRows(at: [indexPath], with: .automatic)
        // Todo: repository
        // Repository.shared.remove(category)
//    }

//    private func deletedCategoryWithItems() {
//        guard let indexOfDefaultCategory = categories.firstIndex(where: { $0.id == ItemsCategory.default.id }) else {
//            return
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//            self.fetchItems()
//
//            let indexPathOfDefaultCategory = IndexPath(row: indexOfDefaultCategory, section: 0)
//            self.tableView.reloadRows(at: [indexPathOfDefaultCategory], with: .automatic)
//        }
//    }
}

extension ManageCategoriesTableView {
    public enum Action {
        case editCategory(id: UUID, name: String)
        case removeCategory(id: UUID)
    }
}
