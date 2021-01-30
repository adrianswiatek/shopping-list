import ShoppingList_ViewModels
import Combine
import UIKit

public final class ItemsTableView: UITableView {
    public var onAction: AnyPublisher<Action, Never> {
        onActionSubject.eraseToAnyPublisher()
    }

    private let onActionSubject: PassthroughSubject<Action, Never>

    public init() {
        self.onActionSubject = .init()

        super.init(frame: .zero, style: .plain)

        self.registerCell(ofType: ItemsTableViewCell.self)
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not supported.")
    }

    public func refreshBackground() {
        if visibleCells.isEmpty {
            setBackgroundLabel("Your shopping list is empty")
        } else {
            backgroundView = nil
        }
    }

    public func selectedItems() -> [ItemToBuyViewModel] {
        let selectedRows = indexPathsForSelectedRows.map { $0.map { $0.row } } ?? []
        return selectedRows.compactMap { itemForCell(at: $0) }
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        separatorStyle = .singleLine
        allowsSelection = false
        allowsMultipleSelectionDuringEditing = true
        rowHeight = 56
        estimatedRowHeight = 56
        tableFooterView = UIView()

        delegate = self
        dragDelegate = self
        dropDelegate = self
    }

    private func itemForCell(at index: Int) -> ItemToBuyViewModel? {
        cellForRow(at: .init(row: index, section: 0)).flatMap { $0 as? ItemsTableViewCell }?.viewModel
    }
}

extension ItemsTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onActionSubject.send(.rowTapped)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onActionSubject.send(.rowTapped)
    }

    public func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completed in
            guard let self = self, let item = self.itemForCell(at: indexPath.row) else {
                return completed(false)
            }

            self.onActionSubject.send(.editItem(item: item))
            completed(true)
        }
        editAction.backgroundColor = .edit
        editAction.image = #imageLiteral(resourceName: "Edit").withRenderingMode(.alwaysTemplate)
        return UISwipeActionsConfiguration(actions: [editAction])
    }

    public func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completed in
            guard let self = self, let item = self.itemForCell(at: indexPath.row) else {
                return completed(false)
            }

            self.onActionSubject.send(.removeItem(uuid: item.uuid))
            completed(true)
        }
        removeAction.backgroundColor = .remove
        removeAction.image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)
        return UISwipeActionsConfiguration(actions: [removeAction])
    }

    public func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        .init(identifier: "ItemsContextMenu" as NSCopying, previewProvider: nil) { [weak self] _ in
            let actions: [UIAction] = [
                self?.moveToListActionForItem(at: indexPath.row),
                self?.removeActionForItem(at: indexPath.row)
            ].compactMap { $0 }

            return UIMenu(title: "", children: actions)
        }
    }

    private func moveToListActionForItem(at index: Int) -> UIAction? {
        itemForCell(at: index).map { item in
            UIAction(title: "Add item to the basket", image: #imageLiteral(resourceName: "AddToBasket"), attributes: []) { [weak self] _ in
                self?.onActionSubject.send(.addItemToBasket(uuid: item.uuid))
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

//    public func tableView(
//        _ tableView: UITableView,
//        viewForHeaderInSection section: Int
//    ) -> UIView? {
//        let headerCell = ItemsTableViewHeaderCell()
//        headerCell.category = categories[section]
//        return headerCell
//        return nil
//    }
}

extension ItemsTableView: UITableViewDragDelegate {
    public func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension ItemsTableView: UITableViewDropDelegate {
    public func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}

    public func tableView(
        _ tableView: UITableView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UITableViewDropProposal {
        .init(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}

extension ItemsTableView {
    public enum Action {
        case addItemToBasket(uuid: UUID)
        case editItem(item: ItemToBuyViewModel)
        case removeItem(uuid: UUID)
        case rowTapped
    }
}
