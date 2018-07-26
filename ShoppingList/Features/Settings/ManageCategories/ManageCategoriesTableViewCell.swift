import UIKit

class ManageCategoriesTableViewCell: UITableViewCell {
    
    var category: Category? {
        didSet {
            if let categoryName = category?.name {
                categoryNameLabel.text = categoryName
            }
            
            if category?.isDefault() == true {
                defaultCategoryImageView.image = #imageLiteral(resourceName: "Star").withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    var itemsInCategory: Int? {
        didSet {
            numberOfItemsInCategoryLabel.text = "Items in category: \(itemsInCategory ?? 0)"
        }
    }
    
    private var defaultCategoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }
    
    private func setupUserInterface() {
        contentView.addSubview(defaultCategoryImageView)
        defaultCategoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        defaultCategoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        defaultCategoryImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        defaultCategoryImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        contentView.addSubview(categoryNameLabel)
        categoryNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        categoryNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        categoryNameLabel.trailingAnchor.constraint(equalTo: defaultCategoryImageView.leadingAnchor, constant: -16).isActive = true
        
        contentView.addSubview(numberOfItemsInCategoryLabel)
        numberOfItemsInCategoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        numberOfItemsInCategoryLabel.trailingAnchor.constraint(equalTo: defaultCategoryImageView.trailingAnchor, constant: -16).isActive = true
        numberOfItemsInCategoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
