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
        .init(tableView) { [weak self] tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ItemsTableViewCell.identifier,
                for: indexPath
            ) as? ItemsTableViewCell

            cell?.viewModel = item
            cell?.delegate = self

            return cell
        }

    private var animateDifferences: Bool

    public init(_ tableView: UITableView) {
        self.tableView = tableView
        self.animateDifferences = true
        self.onActionSubject = .init()
    }

    public func apply(_ sections: [ItemsSectionViewModel]) {
        defer { animateDifferences = true }
        
        var snapshot = NSDiffableDataSourceSnapshot<String, ItemToBuyViewModel>()

        let categories = sections.map { $0.category.name }
        snapshot.appendSections(categories)

        for section in sections {
            snapshot.appendItems(section.items, toSection: section.category.name)
        }

        dataSource.apply(snapshot, animatingDifferences: animateDifferences)
    }

    public func disableAnimationOnce() {
        animateDifferences = false
    }
}

public extension ItemsDataSource {
    enum Action {
        case addItemToBasket(uuid: UUID)
        case openExternalUrl(externalUrl: String)
    }
}

private extension ItemsDataSource {
    final class DataSource: UITableViewDiffableDataSource<String, ItemToBuyViewModel> {
        public init(
            _ tableView: UITableView,
            _ cellProvider: @escaping UITableViewDiffableDataSource<String, ItemToBuyViewModel>.CellProvider
        ) {
            super.init(tableView: tableView, cellProvider: cellProvider)
        }

        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            true
        }

        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            snapshot().sectionIdentifiers[section]
        }
    }
}

extension ItemsDataSource: ItemsTableViewCellDelegate {
    public func itemsTableViewCell(
        _ itemsTableViewCell: ItemsTableViewCell,
        didMoveItemToBasket item: ItemToBuyViewModel
    ) {
        onActionSubject.send(.addItemToBasket(uuid: item.uuid))
    }

    public func itemsTableViewCell(
        _ itemsTableViewCell: ItemsTableViewCell,
        didOpenExternalUrl externalUrl: String
    ) {
        onActionSubject.send(.openExternalUrl(externalUrl: externalUrl))
    }
}
