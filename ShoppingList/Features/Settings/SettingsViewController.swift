import UIKit

final class SettingsViewController: UIViewController {    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = false
        tableView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let manageCategoriesCell: UITableViewCell = {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "Manage Categories"
        cell.textLabel?.textColor = .darkGray
        cell.accessoryType = .disclosureIndicator
        return cell
    }()
    
    lazy var closeBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeScene))
    }()
    
    @objc private func closeScene() {
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUserInterface()
    }
    
    private func initializeUserInterface() {
        title = "Settings"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = closeBarButtonItem
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
