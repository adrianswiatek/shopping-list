import ShoppingList_ViewModels
import Combine
import UIKit

public final class BasketTableView: UITableView {
    public var onAction: AnyPublisher<Action, Never> {
        onActionSubject.eraseToAnyPublisher()
    }

    private let onActionSubject: PassthroughSubject<Action, Never>

    public init() {
        self.onActionSubject = .init()

        super.init(frame: .zero, style: .plain)

        self.registerCell(BasketTableViewCell.self)
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not supported.")
    }

    public func selectedItems() -> [ItemInBasketViewModel] {
        let selectedRows = indexPathsForSelectedRows.map { $0.map { $0.row } } ?? []
        return selectedRows.compactMap { itemForCell(at: $0) }
    }

    public func refreshBackground() {
        if visibleCells.isEmpty {
            setBackgroundLabel("Your basket is empty")
        } else {
            backgroundView = nil
        }
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        allowsSelection = false
        allowsMultipleSelectionDuringEditing = true
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = UITableView.automaticDimension
        tableFooterView = UIView()
        delegate = self
    }

    private func itemForCell(at index: Int) -> ItemInBasketViewModel? {
        cellForRow(at: .init(row: index, section: 0)).flatMap { $0 as? BasketTableViewCell }?.viewModel
    }
}

extension BasketTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onActionSubject.send(.rowTapped)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onActionSubject.send(.rowTapped)
    }

    public func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let item = itemForCell(at: indexPath.row) else {
            return .init()
        }

        let action = UIContextualAction(style: .destructive, title: nil) { [weak self] in
            self?.onActionSubject.send(.removeItem(uuid: item.uuid))
            $2(true)
        }
        action.backgroundColor = .remove
        action.image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)

        return .init(actions: [action])
    }

    public func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        .init(identifier: "BasketContextMenu" as NSCopying, previewProvider: nil) { [weak self] _ in
            let actions: [UIAction] = [
                self?.moveToListActionForItem(at: indexPath.row),
                self?.removeActionForItem(at: indexPath.row)
            ].compactMap { $0 }

            return UIMenu(title: "", children: actions)
        }
    }

    private func moveToListActionForItem(at index: Int) -> UIAction? {
        itemForCell(at: index).map { item in
            UIAction(title: "Move item to the list", image: #imageLiteral(resourceName: "RemoveFromBasket"), attributes: []) { [weak self] _ in
                self?.onActionSubject.send(.moveItemToList(uuid: item.uuid))
            }
        }
    }

    private func removeActionForItem(at index: Int) -> UIAction? {
        itemForCell(at: index).map { item in
            let image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)
            return UIAction(title: "Remove item", image: image, attributes: .destructive) { [weak self] _ in
                self?.onActionSubject.send(.removeItem(uuid: item.uuid))
            }
        }
    }
}

public extension BasketTableView {
    enum Action {
        case moveItemToList(uuid: UUID)
        case removeItem(uuid: UUID)
        case rowTapped
    }
}
