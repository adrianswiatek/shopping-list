import UIKit

class ManageCategoriesTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var categoryName: String? {
        didSet {
            guard let categoryName = categoryName else { return }
            categoryNameLabel.text = categoryName
        }
    }
    
    var itemsInCategory: Int? {
        didSet {
            numberOfItemsInCategoryLabel.text = "Items in category: \(itemsInCategory ?? 0)"
        }
    }
    
    // MARK: - Controles
    
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberOfItemsInCategoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }
    
    private func setupUserInterface() {
        contentView.addSubview(categoryNameLabel)
        categoryNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        categoryNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        categoryNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(numberOfItemsInCategoryLabel)
        numberOfItemsInCategoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        numberOfItemsInCategoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        numberOfItemsInCategoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
