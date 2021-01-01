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
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not supported.")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        separatorStyle = .singleLine
        allowsSelection = false
        allowsMultipleSelectionDuringEditing = false
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 50
        tableFooterView = UIView()

        delegate = self
        dragDelegate = self
        dropDelegate = self

        register(ItemsTableViewCell.self, forCellReuseIdentifier: ItemsTableViewCell.identifier)
    }
}

extension ItemsTableView: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let editItemAction = UIContextualAction(
            style: .normal,
            title: nil) { [unowned self] (action, sourceView, completionHandler) in
//            let item = self.items[indexPath.section][indexPath.row]
//            self.goToEditItemDetailed(with: item)
            completionHandler(true)
        }
        editItemAction.backgroundColor = .edit
        editItemAction.image = #imageLiteral(resourceName: "Edit").withRenderingMode(.alwaysTemplate)
        return UISwipeActionsConfiguration(actions: [editItemAction])
    }

    public func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteItemAction = UIContextualAction(
            style: .destructive,
            title: nil
        ) { [weak self] (action, sourceView, completionHandler) in
            // Todo: command
            // let item = self.items[indexPath.section][indexPath.row]
            // let command = RemoveItemsFromListCommand(item, self)
            // CommandInvoker.shared.execute(command)
            completionHandler(true)
        }
        deleteItemAction.backgroundColor = .delete
        deleteItemAction.image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)
        return UISwipeActionsConfiguration(actions: [deleteItemAction])
    }

    public func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let headerCell = ItemsTableViewHeaderCell()
//        headerCell.category = categories[section]
        return headerCell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
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

    }
}
