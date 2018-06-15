import UIKit

extension ManageCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let builder = EditContextualActionBuilder(
            viewController: self,
            category: categories[indexPath.row]) { [unowned self] in
                // TODO: handle sorting after name update
                let existingCategory = self.categories[indexPath.row]
                let newCategory = existingCategory.getWithChanged(name: $0)
                self.categories[indexPath.row] = newCategory
                
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                Repository.shared.update(newCategory)
        }
        
        return UISwipeActionsConfiguration(actions: [builder.build()])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let category = categories[indexPath.row]
        let builder = DeleteContextualActionBuilder(
            viewController: self,
            category: category,
            isCategoryEmpty: items.filter({ $0.category?.id == category.id }).count == 0,
            deleteCategory: { self.deleteCategory(at: indexPath) },
            deletedCategoryWithItems: {
                if let indexOfDefaultCategory = self.categories.index(where: { $0.id == Category.getDefault().id }) {
                    self.fetchItems()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        let indexPathOfDefaultCategory = IndexPath(row: indexOfDefaultCategory, section: 0)
                        tableView.reloadRows(at: [indexPathOfDefaultCategory], with: .automatic)
                    }
                }
        })
        return UISwipeActionsConfiguration(actions: [builder.build()])
    }
    
    private func deleteCategory(at indexPath: IndexPath) {
        let category = categories.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        Repository.shared.remove(category)
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
