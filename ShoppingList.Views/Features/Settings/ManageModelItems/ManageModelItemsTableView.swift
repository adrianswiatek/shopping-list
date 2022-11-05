import ShoppingList_ViewModels
import Combine
import UIKit

public final class ManageModelItemsTableView: UITableView {
    public var onAction: AnyPublisher<Action, Never> {
        onActionSubject.eraseToAnyPublisher()
    }

    private let onActionSubject: PassthroughSubject<Action, Never>

    public override init(frame: CGRect, style: UITableView.Style) {
        self.onActionSubject = .init()

        super.init(frame: frame, style: style)

        self.registerCell(ManageModelItemsTableViewCell.self)
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not available.")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        allowsSelection = false
        tableFooterView = UIView()
        delegate = self
    }
}

extension ManageModelItemsTableView: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] in
            self?.onActionSubject.send(.doNothing)
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
        guard let modelItem = modelItemForCell(at: indexPath.row) else {
            return .init()
        }

        return .init(actions: [removeAction(for: modelItem)])
    }

    public func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        .init(identifier: "ManageModelItemsContextMenu" as NSCopying, previewProvider: nil) { [weak self] _ in
            let actions: [UIAction] = [
                self?.editActionForModelItem(at: indexPath.row),
                self?.removeActionForModelItem(at: indexPath.row)
            ].compactMap { $0 }

            return UIMenu(title: "", children: actions)
        }
    }

    private func removeAction(for modelItem: ModelItemViewModel) -> UIContextualAction {
        let action: UIContextualAction = .init(style: .destructive, title: nil) { [weak self] in
            self?.onActionSubject.send(.doNothing)
            $2(true)
        }
        action.backgroundColor = .remove
        action.image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)
        return action
    }

    private func editActionForModelItem(at index: Int) -> UIAction? {
        UIAction(
            title: "Edit item name",
            image: #imageLiteral(resourceName: "Edit").withRenderingMode(.alwaysTemplate),
            attributes: []
        ) { [weak self] _ in
            self?.onActionSubject.send(.doNothing)
        }
    }

    private func removeActionForModelItem(at index: Int) -> UIAction? {
//        guard let modelItem = modelItemForCell(at: index) else { return nil }
        let image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)
        return UIAction(title: "Remove model item", image: image, attributes: .destructive) { [weak self] _ in
            self?.onActionSubject.send(.doNothing)
        }
    }

    private func modelItemForCell(at index: Int) -> ModelItemViewModel? {
        cellForRow(at: .init(row: index, section: 0)).flatMap { $0 as? ManageModelItemsTableViewCell }?.viewModel
    }
}

extension ManageModelItemsTableView {
    public enum Action {
        case doNothing
    }
}
