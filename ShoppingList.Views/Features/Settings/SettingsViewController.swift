import ShoppingList_Shared
import UIKit

public final class SettingsViewController: UIViewController {
    private lazy var tableView: UITableView =
        configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.delegate = self
            $0.dataSource = self
            $0.allowsMultipleSelection = false
            $0.backgroundColor = .background
            $0.tableFooterView = UIView()
        }
    
    private let manageCategoriesCell: UITableViewCell =
        configure(.init(style: .default, reuseIdentifier: nil)) {
            $0.textLabel?.text = "Manage Categories"
            $0.textLabel?.textColor = .textPrimary
            $0.backgroundColor = .background
            $0.accessoryType = .disclosureIndicator
        }
    
    private lazy var closeBarButtonItem: UIBarButtonItem =
        UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeScene))

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
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

    @objc
    private func closeScene() {
        dismiss(animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let manageCategoriesViewController = ManageCategoriesViewController()
        navigationController?.pushViewController(manageCategoriesViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return manageCategoriesCell
        default: return UITableViewCell()
        }
    }
}
