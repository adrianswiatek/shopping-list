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
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not available.")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .background
        allowsSelection = false
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = UITableView.automaticDimension
        tableFooterView = UIView()
        delegate = self

        register(ManageCategoriesTableViewCell.self, forCellReuseIdentifier: ManageCategoriesTableViewCell.identifier)
    }
}

extension ManageCategoriesTableView: UITableViewDelegate {
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
            self?.onActionSubject.send(.removeCategory(id: category.uuid))
        }
    }

    private func categoryForCell(at index: Int) -> ItemsCategoryViewModel? {
        cellForRow(at: .init(row: index, section: 0)).flatMap { $0 as? ManageCategoriesTableViewCell }?.viewModel
    }
}

extension ManageCategoriesTableView {
    public enum Action {
        case editCategory(_ category: ItemsCategoryViewModel)
        case removeCategory(id: UUID)
    }
}
