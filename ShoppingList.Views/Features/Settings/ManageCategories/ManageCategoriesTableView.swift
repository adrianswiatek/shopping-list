import ShoppingList_ViewModels
import Combine
import UIKit

public final class ManageCategoriesTableView: UITableView {
    public var onAction: AnyPublisher<Action, Never> {
        onActionSubject.eraseToAnyPublisher()
    }

    private let onActionSubject: PassthroughSubject<Action, Never>

    public override init(frame: CGRect, style: UITableView.Style) {
        self.onActionSubject = .init()

        super.init(frame: frame, style: style)

        self.registerCell(ManageCategoriesTableViewCell.self)
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

extension ManageCategoriesTableView: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let category = categoryForCell(at: indexPath.row) else {
            return .init()
        }

        let action = UIContextualAction(style: .normal, title: nil) { [weak self] in
            self?.onActionSubject.send(.editCategory(category))
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
        guard let category = categoryForCell(at: indexPath.row) else {
            return .init()
        }

        return .init(actions: [removeAction(for: category)])
    }

    public func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        .init(identifier: "ManageCategoriesContextMenu" as NSCopying, previewProvider: nil) { [weak self] _ in
            let actions: [UIAction] = [
                self?.editActionForCategory(at: indexPath.row),
                self?.removeActionForCategory(at: indexPath.row)
            ].compactMap { $0 }

            return UIMenu(title: "", children: actions)
        }
    }

    private func removeAction(for category: ItemsCategoryViewModel) -> UIContextualAction {
        var action: UIContextualAction

        if category.isDefault {
            action = .init(style: .normal, title: "") { $2(false) }
            action.backgroundColor = .systemGray
        } else {
            action = .init(style: .destructive, title: nil) { [weak self] in
                self?.onActionSubject.send(.removeCategory(uuid: category.uuid))
                $2(true)
            }
            action.backgroundColor = .remove
        }

        action.image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)
        return action
    }

    private func editActionForCategory(at index: Int) -> UIAction? {
        guard let category = categoryForCell(at: index) else {
            return nil
        }

        return UIAction(
            title: "Edit category name",
            image: #imageLiteral(resourceName: "Edit").withRenderingMode(.alwaysTemplate),
            attributes: []
        ) { [weak self] _ in
            self?.onActionSubject.send(.editCategory(category))
        }
    }

    private func removeActionForCategory(at index: Int) -> UIAction? {
        guard let category = categoryForCell(at: index), !category.isDefault else { return nil }
        let image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)
        return UIAction(title: "Remove category", image: image, attributes: .destructive) { [weak self] _ in
            self?.onActionSubject.send(.removeCategory(uuid: category.uuid))
        }
    }

    private func categoryForCell(at index: Int) -> ItemsCategoryViewModel? {
        cellForRow(at: .init(row: index, section: 0)).flatMap { $0 as? ManageCategoriesTableViewCell }?.viewModel
    }
}

extension ManageCategoriesTableView {
    public enum Action {
        case editCategory(_ category: ItemsCategoryViewModel)
        case removeCategory(uuid: UUID)
    }
}
