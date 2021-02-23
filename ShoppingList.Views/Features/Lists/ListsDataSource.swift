import ShoppingList_ViewModels
import ShoppingList_Shared
import UIKit

public final class ListsDataSource: UITableViewDiffableDataSource<ListsDataSource.Section, ListViewModel> {
    public init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, list in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ListsTableViewCell.identifier,
                for: indexPath
            ) as? ListsTableViewCell
            cell?.viewModel = list
            return cell
        }
    }

    public func apply(_ lists: [ListViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ListViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(lists, toSection: .main)
        apply(snapshot)
    }

    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}

public extension ListsDataSource {
    enum Section {
        case main
    }
}
