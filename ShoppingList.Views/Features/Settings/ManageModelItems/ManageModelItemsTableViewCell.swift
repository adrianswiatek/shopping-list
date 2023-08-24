import ShoppingList_ViewModels
import ShoppingList_Shared
import UIKit

public final class ManageModelItemsTableViewCell: UITableViewCell {
    public var viewModel: ModelItemViewModel? {
        didSet {
            itemNameLabel.text = viewModel?.name
        }
    }

    private let itemNameLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .textPrimary
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.numberOfLines = 0
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }

    private func setupView() {
        backgroundColor = .background

        setupForItemsWithCategories()
    }

    private func setupForItemsOnly() {
        let marginsGuide = contentView.layoutMarginsGuide

        contentView.addSubview(itemNameLabel)
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: marginsGuide.topAnchor),
            itemNameLabel.leadingAnchor.constraint(lessThanOrEqualTo: marginsGuide.leadingAnchor),
            itemNameLabel.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),
            itemNameLabel.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor)
        ])
    }

    private func setupForItemsWithCategories() {
        let marginsGuide = contentView.layoutMarginsGuide

        contentView.addSubview(itemNameLabel)
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: marginsGuide.topAnchor),
            itemNameLabel.leadingAnchor.constraint(lessThanOrEqualTo: marginsGuide.leadingAnchor),
            itemNameLabel.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor),
            itemNameLabel.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),
        ])
    }
}
