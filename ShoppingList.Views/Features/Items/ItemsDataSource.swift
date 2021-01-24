import ShoppingList_ViewModels
import Combine
import UIKit

public final class ItemsDataSource {
    private let onActionSubject: PassthroughSubject<Action, Never>
    public var onAction: AnyPublisher<Action, Never> {
        onActionSubject.eraseToAnyPublisher()
    }

    private let tableView: UITableView
    private lazy var dataSource: DataSource =
        .init(tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ItemsTableViewCell.identifier,
                for: indexPath
            ) as? ItemsTableViewCell

            cell?.viewModel = item

            let cancellable = cell?.moveToBasketTapped.sink { [weak self] in
                self?.onActionSubject.send(.moveItemToBasket(uuid: $0.uuid))
            }
            cell?.setCancellable(cancellable)

            return cell
        }

    public init(_ tableView: UITableView) {
        self.tableView = tableView
        self.onActionSubject = .init()
    }

    public func apply(_ items: [ItemToBuyViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemToBuyViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot)
    }
}

public extension ItemsDataSource {
    enum Section {
        case main
    }

    enum Action {
        case moveItemToBasket(uuid: UUID)
    }
}

private extension ItemsDataSource {
    final class DataSource: UITableViewDiffableDataSource<ItemsDataSource.Section, ItemToBuyViewModel> {
        public init(
            _ tableView: UITableView,
            _ cellProvider: @escaping UITableViewDiffableDataSource<ItemsDataSource.Section, ItemToBuyViewModel>.CellProvider
        ) {
            super.init(tableView: tableView, cellProvider: cellProvider)
        }

        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            true
        }

//        public func tableView(
//            _ tableView: UITableView,
//            moveRowAt sourceIndexPath: IndexPath,
//            to destinationIndexPath: IndexPath
//        ) {
//            var item = items[sourceIndexPath.section].remove(at: sourceIndexPath.row)
//
//            if sourceIndexPath.section != destinationIndexPath.section {
//                let destinationCategory = categories[destinationIndexPath.section]
//                item = item.withChanged(categoryId: destinationCategory.id)
//                _ = tableView.cellForRow(at: sourceIndexPath) as! ItemsTableViewCell
//                cell.item = item
//                Repository.shared.updateCategory(of: item, to: destinationCategory)
//            }
//
//            items[destinationIndexPath.section].insert(item, at: destinationIndexPath.row)
//            Repository.shared.setItemsOrder(items.flatMap { $0 }, in: currentList, forState: .toBuy)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
//                let sectionIndex = sourceIndexPath.section
//                guard tableView.numberOfRows(inSection: sectionIndex) == 0 else { return }
//
//                self.items.remove(at: sectionIndex)
//                self.categories.remove(at: sectionIndex)
//                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .middle)
//            }
//        }
//
//        public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//            true
//        }
    }
}
