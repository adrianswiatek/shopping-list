import UIKit

extension ManageCategoriesViewController: TextFieldWithCancelDelegate {
    func textFieldWithCancel(_ textFieldWithCancel: TextFieldWithCancel, didReturnWith text: String) {
        let category = Category.new(name: text)
        
        categories.append(category)
        categories.sort { $0.name < $1.name }
        
        Repository.shared.add(category)
        
        guard let index = categories.index(where: { $0.id == category.id }) else { return }
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}
