import UIKit

extension ListsViewController: TextFieldWithCancelDelegate {
    func textFieldWithCancel(_ textFieldWithCancel: TextFieldWithCancel, didReturnWith text: String) {
        let list = List.new(name: getListName(from: text))
        
        lists.insert(list, at: 0)
        Repository.shared.add(list)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        refreshUserInterface()
    }
}
