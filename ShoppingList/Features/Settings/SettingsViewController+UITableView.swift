import UIKit

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let manageCategoriesViewController = ManageCategoriesViewController()
        navigationController?.pushViewController(manageCategoriesViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return manageCategoriesCell
        default: return UITableViewCell()
        }
    }
}
