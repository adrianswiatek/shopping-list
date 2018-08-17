import UIKit

extension ListsViewController: TextFieldWithCancelDelegate {
    func textFieldWithCancel(_ textFieldWithCancel: TextFieldWithCancel, didReturnWith text: String) {
        let list = List.new(name: getName(from: text))
        
        lists.insert(list, at: 0)
        Repository.shared.add(list)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        setScene()
    }
    
    private func getName(from text: String) -> String {
        if text != "" {
            return text
        }
        
        let defaultName = "My List"
        
        let listsWithDefaultName = lists.filter { $0.name.hasPrefix(defaultName) }
        if listsWithDefaultName.count == 0 {
            return defaultName
        }
        
        let newListNameNumber = generateDefaultNameNumber(from: listsWithDefaultName)
        return newListNameNumber == 0 ? defaultName : "\(defaultName) \(newListNameNumber)"
    }
    
    private func generateDefaultNameNumber(from lists: [List]) -> Int {
        let defaultListNameNumbers = lists
            .map { $0.name.components(separatedBy: " ").last ?? "0" }
            .map { Int($0) ?? 0 }
            .sorted()
        
        for number in (0...defaultListNameNumbers.count) {
            guard defaultListNameNumbers.contains(number) else {
                return number
            }
        }
        
        let lastDefaultNameNumber = defaultListNameNumbers.last ?? 0
        return lastDefaultNameNumber + 1
    }
}
