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

        self.registerCell(ItemsTableViewCell.self)
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
        indexPathsForSelectedRows?.compactMap { itemForCell(at: $0) } ?? []
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        allowsSelection = false
        allowsMultipleSelectionDuringEditing = true
        dragInteractionEnabled = true
        rowHeight = 56
        estimatedRowHeight = 56
        tableFooterView = UIView()

        delegate = self
        dragDelegate = self
        dropDelegate = self
    }

    private func itemForCell(at indexPath: IndexPath) -> ItemToBuyViewModel? {
        cellForRow(at: indexPath).flatMap { $0 as? ItemsTableViewCell }?.viewModel
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
        guard let item = itemForCell(at: indexPath) else {
            return .init()
        }

        let action = UIContextualAction(style: .normal, title: nil) { [weak self] in
            self?.onActionSubject.send(.editItem(item: item))
            $2(true)
        }
        action.backgroundColor = .edit
        action.image = #imageLiteral(resourceName: "Edit").withRenderingMode(.alwaysTemplate)

        return .init(actions: [action])
    }

    public func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let item = itemForCell(at: indexPath) else {
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
        .init(identifier: "ItemsContextMenu" as NSCopying, previewProvider: nil) { [weak self] _ in
            let actions: [UIAction] = [
                self?.moveToListActionForItem(at: indexPath),
                self?.editActionForItem(at: indexPath),
                self?.removeActionForItem(at: indexPath)
            ].compactMap { $0 }

            return UIMenu(title: "", children: actions)
        }
    }

    private func moveToListActionForItem(at indexPath: IndexPath) -> UIAction? {
        itemForCell(at: indexPath).map { item in
            UIAction(title: "Add item to the basket", image: #imageLiteral(resourceName: "AddToBasket"), attributes: []) { [weak self] _ in
                self?.onActionSubject.send(.addItemToBasket(uuid: item.uuid))
            }
        }
    }

    private func editActionForItem(at indexPath: IndexPath) -> UIAction? {
        itemForCell(at: indexPath).map { item in
            let image = #imageLiteral(resourceName: "Edit").withRenderingMode(.alwaysTemplate)
            return UIAction(title: "Edit item", image: image, attributes: []) { [weak self] _ in
                self?.onActionSubject.send(.editItem(item: item))
            }
        }
    }

    private func removeActionForItem(at indexPath: IndexPath) -> UIAction? {
        itemForCell(at: indexPath).map { item in
            let image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)
            return UIAction(title: "Remove item", image: image, attributes: .destructive) { [weak self] _ in
                self?.onActionSubject.send(.removeItem(uuid: item.uuid))
            }
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        dataSource?.tableView?(tableView, titleForHeaderInSection: section).map {
            let headerCell = ItemsTableViewHeaderCell()
            headerCell.setTitle($0)
            return headerCell
        }
    }
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
    public func tableView(
        _ tableView: UITableView,
        performDropWith coordinator: UITableViewDropCoordinator
    ) {
        guard
            let sourceIndexPath = coordinator.items.first?.sourceIndexPath,
            let destinationIndexPath = coordinator.destinationIndexPath
        else {
            return
        }

        onActionSubject.send(.moveItem(
            fromIndexPath: sourceIndexPath,
            toIndexPath: destinationIndexPath
        ))
    }

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
        case moveItem(fromIndexPath: IndexPath, toIndexPath: IndexPath)
        case removeItem(uuid: UUID)
        case rowTapped
    }
}
