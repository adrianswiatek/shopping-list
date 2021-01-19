import ShoppingList_ViewModels
import Combine
import UIKit

public final class BasketDataSource {
    private let onActionSubject: PassthroughSubject<BasketTableViewCell.Action, Never>
    public var onAction: AnyPublisher<BasketTableViewCell.Action, Never> {
        onActionSubject.eraseToAnyPublisher()
    }

    private let tableView: UITableView
    private lazy var dataSource: UITableViewDiffableDataSource<BasketDataSource.Section, ItemInBasketViewModel> = {
        .init(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: BasketTableViewCell.identifier,
                for: indexPath
            ) as? BasketTableViewCell

            cell?.viewModel = item

            let cancellable = cell?.onAction.sink { [weak self] in
                self?.onActionSubject.send($0)
            }
            cell?.setCancellable(cancellable)

            return cell
        }
    }()

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
}
