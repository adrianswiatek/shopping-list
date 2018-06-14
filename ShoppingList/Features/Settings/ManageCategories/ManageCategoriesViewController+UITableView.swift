import UIKit

extension ManageCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let isDefaultCategory = categories[indexPath.row].id == Category.getDefault().id
        
        let editItemAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] (action, sourceView, completionHandler) in
            guard !isDefaultCategory else {
                let alertController = UIAlertController(title: "", message: "You can not edit default category.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alertController, animated: true) { completionHandler(false) }
                return
            }
            
            let alertController = UIAlertController(title: "Edit category", message: nil, preferredStyle: .alert)
            alertController.addTextField { [unowned self] textField in
                textField.text = self.categories[indexPath.row].name
                textField.clearButtonMode = .whileEditing
            }
            
            let saveAlertAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
                // TODO: handle sorting after name update
                let existingCategory = self.categories[indexPath.row]
                let newCategory = existingCategory.getWithChanged(name: alertController.textFields?[0].text ?? "")
                self.categories[indexPath.row] = newCategory
                
                tableView.reloadRows(at: [indexPath], with: .automatic)
                Repository.shared.update(newCategory)
                
                completionHandler(true)
            }
            
            let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in completionHandler(false) }
            
            alertController.addAction(saveAlertAction)
            alertController.addAction(cancelAlertAction)
            
            self.present(alertController, animated: true)
        }
        editItemAction.backgroundColor = isDefaultCategory ? #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1) : #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        editItemAction.image = #imageLiteral(resourceName: "Edit")
        return UISwipeActionsConfiguration(actions: [editItemAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let isDefaultCategory = categories[indexPath.row].id == Category.getDefault().id
        
        let deleteItemAction = UIContextualAction(style: .normal, title: "Delete") { [unowned self] (action, sourceView, completionHandler) in
            guard !isDefaultCategory else {
                let alertController = UIAlertController(title: "", message: "You can not delete default category.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in completionHandler(false) })
                self.present(alertController, animated: true)
                return
            }
            
            let category = self.categories[indexPath.row]
            let numberOfItemsInCategory = self.items.filter({ $0.category?.id == category.id }).count
            if numberOfItemsInCategory == 0 {
                self.deleteCategory(at: indexPath)
                completionHandler(true)
                return
            }
            
            let alertMessage = "There are items related with this category. If continue, all category items will be swapped to default category."
            let alertController = UIAlertController(title: "Delete category", message: alertMessage, preferredStyle: .alert)
            let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in completionHandler(false) }
            let deleteAlertAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in
                self.deleteCategory(at: indexPath)
                if let indexOfDefaultCategory = self.categories.index(where: { $0.id == Category.getDefault().id }) {
                    self.fetchItems()
                    let indexPathOfDefaultCategory = IndexPath(row: indexOfDefaultCategory, section: 0)
                    tableView.reloadRows(at: [indexPathOfDefaultCategory], with: .none)
                }
                completionHandler(true)
            }
            alertController.addAction(cancelAlertAction)
            alertController.addAction(deleteAlertAction)
            self.present(alertController, animated: true)
        }
        deleteItemAction.backgroundColor = isDefaultCategory ? #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        deleteItemAction.image = #imageLiteral(resourceName: "Trash")
        return UISwipeActionsConfiguration(actions: [deleteItemAction])
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
