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

        register(ListsTableViewCell.self, forCellReuseIdentifier: ListsTableViewCell.identifier)
    }
}

extension ListsTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let list = listForCell(at: indexPath.row) else { return }
        onActionSubject.send(.selectList(id: list))
    }

    public func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        .init(identifier: "ListsContextMenu" as NSCopying, previewProvider: nil) { [weak self] _ in
            let actions: [UIAction] = [
                self?.clearItemsToBuyForList(at: indexPath.row),
                self?.clearBasketForList(at: indexPath.row),
                self?.editActionForList(at: indexPath.row),
                self?.removeActionForList(at: indexPath.row)
            ].compactMap { $0 }

            return UIMenu(title: "", children: actions)
        }
    }

    private func removeActionForList(at index: Int) -> UIAction? {
        guard let list = listForCell(at: index) else { return nil }
        let image = UIImage(systemName: "trash.fill")
        return UIAction(title: "Remove list", image: image, attributes: .destructive) { [weak self] _ in
            self?.onActionSubject.send(.removeList(id: list.uuid))
            }
    }

    private func editActionForList(at index: Int) -> UIAction? {
        guard let list = listForCell(at: index) else { return nil }
        return UIAction(title: "Edit list", image: UIImage(systemName: "pencil"), attributes: []) { [weak self] _ in
            self?.onActionSubject.send(.editList(id: list.uuid, name: list.name))
        }
    }

    private func clearItemsToBuyForList(at index: Int) -> UIAction? {
        guard let list = listForCell(at: index) else { return nil }
        let attributes: UIMenuElement.Attributes = list.hasItemsToBuy ? .destructive : .hidden
        return UIAction(title: "Clear items to buy", image: nil, attributes: attributes) { [weak self] _ in
            self?.onActionSubject.send(.clearItemsToBuy(id: list.uuid))
        }
    }

    private func clearBasketForList(at index: Int) -> UIAction? {
        guard let list = listForCell(at: index) else { return nil }
        let attributes: UIMenuElement.Attributes = list.hasItemsInBasket ? .destructive : .hidden
        return UIAction(title: "Clear items in the basket", image: nil, attributes: attributes) { [weak self] _ in
            self?.onActionSubject.send(.clearBasket(id: list.uuid))
        }
    }

    private func listForCell(at index: Int) -> ListViewModel? {
        cellForRow(at: .init(row: index, section: 0)).flatMap { $0 as? ListsTableViewCell }?.viewModel
    }
}

extension ListsTableView {
    public enum Action {
        case clearBasket(id: UUID)
        case clearItemsToBuy(id: UUID)
        case editList(id: UUID, name: String)
        case removeList(id: UUID)
        case selectList(id: ListViewModel)
    }
}