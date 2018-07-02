import UIKit

extension ListsViewController: ItemsViewControllerDelegate {
    func itemsViewControllerDidDismiss(_ itemsViewController: ItemsViewController, withUpdated lists: [List]) {
        let startingIndexPaths = getIndexPaths(of: lists)
        fetchLists()
        let endingIndexPaths = getIndexPaths(of: lists)
        updateTableView(startingIndexPaths, endingIndexPaths)
    }
    
    private func getIndexPaths(of lists: [List]) -> [IndexPath] {
        return lists.compactMap { self.getIndexPath(of: $0) }
    }
    
    private func getIndexPath(of list: List) -> IndexPath? {
        guard let index = lists.index(where: { $0.id == list.id }) else { return nil }
        return IndexPath(row: index, section: 0)
    }
    
    private func updateTableView(_ startingIndexPaths: [IndexPath], _ endingIndexPaths: [IndexPath]) {
        for index in (0..<startingIndexPaths.count) {
            let startingIndexPath = startingIndexPaths[index]
            let endingIndexPath = endingIndexPaths[index]
            guard startingIndexPath != endingIndexPath else { continue }
            
            tableView.moveRow(at: startingIndexPath, to: endingIndexPath)
        }
        
        tableView.reloadRows(at: endingIndexPaths, with: .none)
    }
}
