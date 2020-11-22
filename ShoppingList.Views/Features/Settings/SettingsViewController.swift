import UIKit

final class SettingsViewController: UIViewController {    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = false
        tableView.backgroundColor = .background
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let manageCategoriesCell: UITableViewCell = {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "Manage Categories"
        cell.textLabel?.textColor = .textPrimary
        cell.backgroundColor = .background
        cell.accessoryType = .disclosureIndicator
        return cell
    }()
    
    lazy var closeBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeScene))
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
        navigationController?.navigationBar.backgroundColor = .background
        navigationItem.leftBarButtonItem = closeBarButtonItem
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
