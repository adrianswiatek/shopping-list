import ShoppingList_ViewModels
import ShoppingList_Shared
import UIKit

public final class ListsTableViewCell: UITableViewCell {
    public var viewModel: ListViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            nameLabel.text = viewModel.name
            numberOfItemsValueLabel.text = String(viewModel.numberOfItemsToBuy)
            hasItemsInBaskekValueLabel.text = viewModel.hasItemsInBasket ? "Yes" : "No"
            updateDateValueLabel.text = viewModel.formattedUpdateDate
        }
    }

    private let nameLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .textPrimary
        $0.font = .boldSystemFont(ofSize: 18)
        $0.numberOfLines = 0
    }

    private let numberOfItemsLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Items to buy:"
        $0.textColor = .textSecondary
        $0.font = .systemFont(ofSize: 14)
    }

    private let numberOfItemsValueLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "0"
        $0.textColor = .textPrimary
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }

    private let hasItemsInBasketLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Has items in basket:"
        $0.textColor = .textSecondary
        $0.font = .systemFont(ofSize: 14)
    }

    private let hasItemsInBaskekValueLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "No"
        $0.textColor = .textPrimary
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }

    private let updateDateLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Updated:"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .textSecondary
    }
    
    private let updateDateValueLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .textPrimary
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }

    private func setupView() {
        backgroundColor = .background

        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        contentView.addSubview(numberOfItemsLabel)
        NSLayoutConstraint.activate([
            numberOfItemsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            numberOfItemsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4)
        ])

        contentView.addSubview(hasItemsInBasketLabel)
        NSLayoutConstraint.activate([
            hasItemsInBasketLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            hasItemsInBasketLabel.topAnchor.constraint(equalTo: numberOfItemsLabel.bottomAnchor, constant: 4)
        ])

        contentView.addSubview(updateDateLabel)
        NSLayoutConstraint.activate([
            updateDateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            updateDateLabel.topAnchor.constraint(equalTo: hasItemsInBasketLabel.bottomAnchor, constant: 4),
            updateDateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            updateDateLabel.widthAnchor.constraint(equalTo: hasItemsInBasketLabel.widthAnchor)
        ])

        contentView.addSubview(numberOfItemsValueLabel)
        NSLayoutConstraint.activate([
            numberOfItemsValueLabel.leadingAnchor.constraint(equalTo: hasItemsInBasketLabel.trailingAnchor, constant: 8),
            numberOfItemsValueLabel.centerYAnchor.constraint(equalTo: numberOfItemsLabel.centerYAnchor)
        ])

        contentView.addSubview(hasItemsInBaskekValueLabel)
        NSLayoutConstraint.activate([
            hasItemsInBaskekValueLabel.leadingAnchor.constraint(equalTo: hasItemsInBasketLabel.trailingAnchor, constant: 8),
            hasItemsInBaskekValueLabel.centerYAnchor.constraint(equalTo: hasItemsInBasketLabel.centerYAnchor)
        ])

        contentView.addSubview(updateDateValueLabel)
        NSLayoutConstraint.activate([
            updateDateValueLabel.leadingAnchor.constraint(equalTo: hasItemsInBasketLabel.trailingAnchor, constant: 8),
            updateDateValueLabel.centerYAnchor.constraint(equalTo: updateDateLabel.centerYAnchor)
        ])
    }
}
