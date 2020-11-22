import UIKit

final class ManageCategoriesTableViewCell: UITableViewCell {
    var category: Category? {
        didSet {
            if let categoryName = category?.name {
                categoryNameLabel.text = categoryName
            }
            
            defaultCategoryImageView.image = category?.isDefault() == true
                ? #imageLiteral(resourceName: "Star").withRenderingMode(.alwaysTemplate)
                : nil
        }
    }
    
    var itemsInCategory: Int? {
        didSet {
            numberOfItemsInCategoryLabel.text = "Items in category: \(itemsInCategory ?? 0)"
        }
    }
    
    private var defaultCategoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .textSecondary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberOfItemsInCategoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textSecondary
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }
    
    private func setupUserInterface() {
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
