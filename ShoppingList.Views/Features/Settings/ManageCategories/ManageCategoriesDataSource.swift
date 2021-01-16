import ShoppingList_ViewModels
import ShoppingList_Shared
import UIKit

public final class ManageCategoriesDataSource: UITableViewDiffableDataSource<ManageCategoriesDataSource.Section, ItemsCategoryViewModel> {
    public init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, category in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ManageCategoriesTableViewCell.identifier,
                for: indexPath
            ) as? ManageCategoriesTableViewCell
            cell?.viewModel = category
            return cell
        }
    }

    public func apply(_ categories: [ItemsCategoryViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemsCategoryViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(categories, toSection: .main)
        apply(snapshot)
    }
}

public extension ManageCategoriesDataSource {
    enum Section {
        case main
    }
}
