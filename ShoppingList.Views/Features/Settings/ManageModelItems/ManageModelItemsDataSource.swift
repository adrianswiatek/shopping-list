import ShoppingList_ViewModels
import ShoppingList_Shared
import UIKit

public final class ManageModelItemsDataSource: UITableViewDiffableDataSource<ManageModelItemsDataSource.Section, ModelItemViewModel> {
    public init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, modelItem in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ManageModelItemsTableViewCell.identifier,
                for: indexPath
            ) as? ManageModelItemsTableViewCell
            cell?.viewModel = modelItem
            return cell
        }
    }

    public func apply(_ modelItems: [ModelItemViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ModelItemViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(modelItems, toSection: .main)
        apply(snapshot)
    }

    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}

public extension ManageModelItemsDataSource {
    enum Section {
        case main
    }
}
