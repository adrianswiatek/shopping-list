import ShoppingList_ViewModels
import Combine
import UIKit

public final class ListsTableView: UITableView {
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
        tableFooterView = UIView()
        estimatedRowHeight = 90
        backgroundColor = .background
        delegate = self

        registerCell(ListsTableViewCell.self)
    }
}

extension ListsTableView: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let list = listForCell(at: indexPath.row) else {
            return .init()
        }

        let action = UIContextualAction(style: .normal, title: nil) { [weak self] in
            self?.onActionSubject.send(.editList(list))
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
        guard let list = listForCell(at: indexPath.row) else {
            return .init()
        }

        let action = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completed in
            completed(true)
            self?.onActionSubject.send(.removeList(uuid: list.uuid))
        }
        action.backgroundColor = .remove
        action.image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)

        return .init(actions: [action])
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let list = listForCell(at: indexPath.row) else { return }
        onActionSubject.send(.selectList(list))
    }

    public func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        .init(identifier: "ListsContextMenu" as NSCopying, previewProvider: nil) { [weak self] _ in
            let actions: [UIAction] = [
                self?.editActionForList(at: indexPath.row),
                self?.clearItemsToBuyForList(at: indexPath.row),
                self?.clearBasketForList(at: indexPath.row),
                self?.removeActionForList(at: indexPath.row)
            ].compactMap { $0 }

            return UIMenu(title: "", children: actions)
        }
    }

    private func editActionForList(at index: Int) -> UIAction? {
        guard let list = listForCell(at: index) else { return nil }
        let image = #imageLiteral(resourceName: "Edit").withRenderingMode(.alwaysTemplate)
        return UIAction(title: "Edit list", image: image, attributes: []) { [weak self] _ in
            self?.onActionSubject.send(.editList(list))
        }
    }

    private func clearItemsToBuyForList(at index: Int) -> UIAction? {
        guard let list = listForCell(at: index) else { return nil }
        let attributes: UIMenuElement.Attributes = list.hasItemsToBuy ? .destructive : .hidden
        return UIAction(title: "Clear items to buy", image: nil, attributes: attributes) { [weak self] _ in
            self?.onActionSubject.send(.clearItemsToBuy(uuid: list.uuid))
        }
    }

    private func clearBasketForList(at index: Int) -> UIAction? {
        guard let list = listForCell(at: index) else { return nil }
        let attributes: UIMenuElement.Attributes = list.hasItemsInBasket ? .destructive : .hidden
        return UIAction(title: "Clear items in the basket", image: nil, attributes: attributes) { [weak self] _ in
            self?.onActionSubject.send(.clearBasket(uuid: list.uuid))
        }
    }

    private func removeActionForList(at index: Int) -> UIAction? {
        guard let list = listForCell(at: index) else { return nil }
        let image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)
        return UIAction(title: "Remove list", image: image, attributes: .destructive) { [weak self] _ in
            self?.onActionSubject.send(.removeList(uuid: list.uuid))
        }
    }

    private func listForCell(at index: Int) -> ListViewModel? {
        cellForRow(at: .init(row: index, section: 0)).flatMap { $0 as? ListsTableViewCell }?.viewModel
    }
}

extension ListsTableView {
    public enum Action {
        case clearBasket(uuid: UUID)
        case clearItemsToBuy(uuid: UUID)
        case editList(_ list: ListViewModel)
        case removeList(uuid: UUID)
        case selectList(_ list: ListViewModel)
    }
}
