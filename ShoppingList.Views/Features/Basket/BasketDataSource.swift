import ShoppingList_ViewModels
import Combine
import UIKit

public final class BasketDataSource {
    private let onActionSubject: PassthroughSubject<Action, Never>
    public var onAction: AnyPublisher<Action, Never> {
        onActionSubject.eraseToAnyPublisher()
    }

    private let tableView: UITableView
    private lazy var dataSource: DataSource =
        .init(tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: BasketTableViewCell.identifier,
                for: indexPath
            ) as? BasketTableViewCell

            cell?.viewModel = item

            let cancellable = cell?.moveToListTapped.sink { [weak self] in
                self?.onActionSubject.send(.moveItemToList(uuid: $0.uuid))
            }
            cell?.setCancellable(cancellable)

            return cell
        }

    public init(_ tableView: UITableView) {
        self.tableView = tableView
        self.onActionSubject = .init()
    }

    public func apply(_ items: [ItemInBasketViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemInBasketViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot)
    }
}

public extension BasketDataSource {
    enum Section {
        case main
    }

    enum Action {
        case moveItemToList(uuid: UUID)
    }
}

private extension BasketDataSource {
    final class DataSource: UITableViewDiffableDataSource<BasketDataSource.Section, ItemInBasketViewModel> {
        public init(
            _ tableView: UITableView,
            _ cellProvider: @escaping UITableViewDiffableDataSource<BasketDataSource.Section, ItemInBasketViewModel>.CellProvider
        ) {
            super.init(tableView: tableView, cellProvider: cellProvider)
        }

        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            true
        }
    }
}
