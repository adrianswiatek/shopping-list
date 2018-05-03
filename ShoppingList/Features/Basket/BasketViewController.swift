import UIKit

class BasketViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(BasketTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var editButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: #selector(editList))
    }()
    
    lazy var actionButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showActions))
    }()
    
    lazy var regularToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.setItems([
            editButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            actionButton,
            ], animated: true)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "Trash"), style: .plain, target: self, action: #selector(deleteSelected))
        button.isEnabled = false
        return button
    }()
    
    lazy var restoreButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "RemoveFromBasket"), style: .plain, target: self, action: #selector(restoreSelected))
        button.isEnabled = false
        return button
    }()
    
    lazy var editToolbar: UIToolbar = {
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 16
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton =
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelListEditing))
        cancelButton.style = .done
        
        let toolbar = UIToolbar()
        toolbar.setItems([cancelButton, flexibleSpace, deleteButton, fixedSpace, restoreButton], animated: true)
        toolbar.alpha = 0
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshScene()
        tableView.reloadData()
    }
    
    private func setupUserInterface() {
        title = "Basket"
        view.backgroundColor = .white

        view.addSubview(regularToolbar)
        regularToolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        regularToolbar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        regularToolbar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        regularToolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(editToolbar)
        editToolbar.bottomAnchor.constraint(equalTo: regularToolbar.bottomAnchor).isActive = true
        editToolbar.leftAnchor.constraint(equalTo: regularToolbar.leftAnchor).isActive = true
        editToolbar.rightAnchor.constraint(equalTo: regularToolbar.rightAnchor).isActive = true
        editToolbar.heightAnchor.constraint(equalTo: regularToolbar.heightAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: regularToolbar.topAnchor).isActive = true
    }
    
    func refreshScene() {
        if Repository.ItemsInBasket.any {
            actionButton.isEnabled = true
            editButton.isEnabled = true
            tableView.backgroundView = nil
        } else {
            actionButton.isEnabled = false
            editButton.isEnabled = false
            tableView.setTextIfEmpty("Your basket is empty")
        }
    }
    
    @objc private func showActions(_ sender: UIBarButtonItem) {
        let restoreAllAction = UIAlertAction(title: "Restore all", style: .default) { [unowned self] action in
            let restoredItems = Repository.ItemsInBasket.restoreAll()
            let indicesOfRestoredItems = (0..<restoredItems.count).map { $0 }
            self.tableView.deleteRows(at: indicesOfRestoredItems, with: .left)
            self.refreshScene()
        }
        
        let deleteAllAction = UIAlertAction(title: "Delete all", style: .destructive) { [unowned self] action in
            let removedItems = Repository.ItemsInBasket.removeAll()
            let indicesOfRemovedItems = (0..<removedItems.count).map { $0 }
            self.tableView.deleteRows(at: indicesOfRemovedItems)
            self.refreshScene()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(restoreAllAction)
        alertController.addAction(deleteAllAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc private func editList() {
        tableView.setEditing(true, animated: true)
        regularToolbar.alpha = 0
        editToolbar.alpha = 1
    }
    
    @objc private func cancelListEditing() {
        tableView.setEditing(false, animated: true)
        regularToolbar.alpha = 1
        editToolbar.alpha = 0
    }
    
    @objc private func deleteSelected() {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
        
        let selectedRows = selectedIndexPaths.map { $0.row }
        Repository.ItemsInBasket.removeItems(at: selectedRows)
        tableView.deleteRows(at: selectedRows)
        
        setToolbarButtonsEditability(with: tableView)
    }
    
    @objc private func restoreSelected() {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
        
        let selectedRows = selectedIndexPaths.map { $0.row }
        Repository.ItemsInBasket.restoreItems(at: selectedRows)
        tableView.deleteRows(at: selectedRows, with: .left)
        
        setToolbarButtonsEditability(with: tableView)
    }
}
