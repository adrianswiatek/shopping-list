import UIKit

extension ManageCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let builder = EditContextualActionBuilder(
            viewController: self,
            category: categories[indexPath.row],
            saved: { self.categoryEdited(to: $0, at: indexPath) },
            savedDefault: { self.defaultCategoryNameChanged(to: $0, at: indexPath) })
        
        return UISwipeActionsConfiguration(actions: [builder.build()])
    }
    
    private func defaultCategoryNameChanged(to name: String, at indexPath: IndexPath) {
        let updatedCategory = updateCategory(to: name, at: indexPath)
        updateTableViewAfterCategoryUpdate(currentIndexPath: indexPath, category: updatedCategory)
        Repository.shared.defaultCategoryName = updatedCategory.name
    }
    
    private func categoryEdited(to name: String, at indexPath: IndexPath) {
        let updatedCategory = updateCategory(to: name, at: indexPath)
        updateTableViewAfterCategoryUpdate(currentIndexPath: indexPath, category: updatedCategory)
        Repository.shared.update(updatedCategory)
    }
    
    private func updateCategory(to name: String, at indexPath: IndexPath) -> Category {
        let existingCategory = categories[indexPath.row]
        let newCategory = existingCategory.getWithChanged(name: name)
        categories[indexPath.row] = newCategory
        categories.sort { $0.name < $1.name }
        return newCategory
    }
    
    private func updateTableViewAfterCategoryUpdate(currentIndexPath: IndexPath, category: Category) {
        guard let newCategoryIndex = categories.index(where: { $0.id == category.id }) else { return }
        
        let newIndexPath = IndexPath(row: newCategoryIndex, section: 0)
        if newIndexPath != currentIndexPath {
            tableView.moveRow(at: currentIndexPath, to: newIndexPath)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) { [unowned self] in
            self.tableView.reloadRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let category = categories[indexPath.row]
        let builder = DeleteContextualActionBuilder(
            viewController: self,
            category: category,
            isCategoryEmpty: items.filter({ $0.category?.id == category.id }).count == 0,
            deleteCategory: { self.deleteCategory(at: indexPath) },
            deletedCategoryWithItems: deletedCategoryWithItems)
        return UISwipeActionsConfiguration(actions: [builder.build()])
    }
    
    private func deleteCategory(at indexPath: IndexPath) {
        let category = categories.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        Repository.shared.remove(category)
    }
    
    private func deletedCategoryWithItems() {
        guard let indexOfDefaultCategory = categories.index(where: { $0.id == Category.getDefault().id }) else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.fetchItems()
            
            let indexPathOfDefaultCategory = IndexPath(row: indexOfDefaultCategory, section: 0)
            self.tableView.reloadRows(at: [indexPathOfDefaultCategory], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ManageCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ManageCategoriesTableViewCell
        let category = categories[indexPath.row]
        cell.categoryName = category.name
        cell.itemsInCategory = items
            .map { $0.category ?? Category.getDefault() }
            .filter { $0.id == category.id }
            .count
        return cell
    }
}
