import UIKit

extension ItemsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editItemAction = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            completionHandler(true)
        }
        editItemAction.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        editItemAction.image = #imageLiteral(resourceName: "Edit")
        return UISwipeActionsConfiguration(actions: [editItemAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItemAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] (action, sourceView, completionHandler) in
            let item = self.items.remove(at: indexPath.row)
            self.tableView.deleteRow(at: indexPath.row)
            
            Repository.shared.remove(item)
            
            self.refreshScene()
            completionHandler(true)
        }
        deleteItemAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        deleteItemAction.image = #imageLiteral(resourceName: "Trash")
        return UISwipeActionsConfiguration(actions: [deleteItemAction])
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        
        view.addSubview(cancelAddingItemButton)
        cancelAddingItemButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        cancelAddingItemButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        cancelAddingItemButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        let cancelButtonTrailingConstraint =
            NSLayoutConstraint(
            item: cancelAddingItemButton,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: view,
            attribute: .trailing,
            multiplier: 1,
            constant: 48)
        
        cancelButtonTrailingConstraint.identifier = "CancelButtonTrailingConstraint"
        cancelButtonTrailingConstraint.isActive = true
        
        view.addSubview(addItemTextField)
        addItemTextField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        addItemTextField.rightAnchor.constraint(equalTo: cancelAddingItemButton.leftAnchor).isActive = true
        addItemTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        addItemTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.item = items[indexPath.row]
        cell.delegate = self
        
        return cell
    }
}
