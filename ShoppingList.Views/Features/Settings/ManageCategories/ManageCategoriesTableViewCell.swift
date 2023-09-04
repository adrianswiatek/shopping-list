import ShoppingList_ViewModels
import ShoppingList_Shared
import UIKit

public final class ManageCategoriesTableViewCell: UITableViewCell {
    public var viewModel: ItemsCategoryViewModel? {
        didSet {
            if let categoryName = viewModel?.name {
                categoryNameLabel.text = categoryName
            }
            
            defaultCategoryImageView.image = viewModel?.isDefault == true
                ? #imageLiteral(resourceName: "Star").withRenderingMode(.alwaysTemplate)
                : nil

            numberOfItemsInCategoryLabel.text = "Items in category: \(viewModel?.itemsInCategory ?? 0)"
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
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }

    private func setupView() {
        backgroundColor = .background

        let marginsGuide = contentView.layoutMarginsGuide

        contentView.addSubview(defaultCategoryImageView)
        NSLayoutConstraint.activate([
            defaultCategoryImageView.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),
            defaultCategoryImageView.centerYAnchor.constraint(equalTo: marginsGuide.centerYAnchor),
            defaultCategoryImageView.heightAnchor.constraint(equalToConstant: 24),
        ])

        contentView.addSubview(categoryNameLabel)
        NSLayoutConstraint.activate([
            categoryNameLabel.topAnchor.constraint(equalTo: marginsGuide.topAnchor),
            categoryNameLabel.leadingAnchor.constraint(lessThanOrEqualTo: marginsGuide.leadingAnchor),
            categoryNameLabel.trailingAnchor.constraint(equalTo: defaultCategoryImageView.leadingAnchor),
            categoryNameLabel.heightAnchor.constraint(equalToConstant: 24)
        ])

        contentView.addSubview(numberOfItemsInCategoryLabel)
        NSLayoutConstraint.activate([
            numberOfItemsInCategoryLabel.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor),
            numberOfItemsInCategoryLabel.leadingAnchor.constraint(equalTo: categoryNameLabel.leadingAnchor),
            numberOfItemsInCategoryLabel.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor)
        ])
    }
}
