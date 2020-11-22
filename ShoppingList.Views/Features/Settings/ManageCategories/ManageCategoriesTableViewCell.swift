import ShoppingList_Domain
import ShoppingList_Shared
import UIKit

public final class ManageCategoriesTableViewCell: UITableViewCell {
    public var category: ItemsCategory? {
        didSet {
            if let categoryName = category?.name {
                categoryNameLabel.text = categoryName
            }
            
            defaultCategoryImageView.image = category?.isDefault == true
                ? #imageLiteral(resourceName: "Star").withRenderingMode(.alwaysTemplate)
                : nil
        }
    }
    
    public var itemsInCategory: Int? {
        didSet {
            numberOfItemsInCategoryLabel.text = "Items in category: \(itemsInCategory ?? 0)"
        }
    }
    
    private var defaultCategoryImageView: UIImageView = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .textSecondary
    }
    
    private let categoryNameLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .textPrimary
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.numberOfLines = 0
    }
    
    private let numberOfItemsInCategoryLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .textSecondary
        $0.font = .systemFont(ofSize: 14)
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupview()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }
    
    private func setupview() {
        backgroundColor = .background

        contentView.addSubview(defaultCategoryImageView)
        NSLayoutConstraint.activate([
            defaultCategoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            defaultCategoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            defaultCategoryImageView.heightAnchor.constraint(equalToConstant: 24),
            defaultCategoryImageView.widthAnchor.constraint(equalTo: defaultCategoryImageView.heightAnchor)
        ])

        contentView.addSubview(categoryNameLabel)
        NSLayoutConstraint.activate([
            categoryNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            categoryNameLabel.trailingAnchor.constraint(equalTo: defaultCategoryImageView.leadingAnchor, constant: -8)
        ])

        contentView.addSubview(numberOfItemsInCategoryLabel)
        NSLayoutConstraint.activate([
            numberOfItemsInCategoryLabel.leadingAnchor.constraint(equalTo: categoryNameLabel.leadingAnchor),
            numberOfItemsInCategoryLabel.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: 4),
            numberOfItemsInCategoryLabel.trailingAnchor.constraint(equalTo: categoryNameLabel.trailingAnchor),
            numberOfItemsInCategoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
