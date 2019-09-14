import UIKit

final class BasketTableViewCell: UITableViewCell {
    var item: Item? {
        didSet {
            itemNameLabel.text = item?.name
        }
    }
    
    var delegate: RemoveFromBasketDelegate?

    private lazy var itemNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        label.text = "Item name"
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var removeFromBasketButton: UIButton = {
        let button = UIButton(type: .system)
        button.setListItemButton(with: #imageLiteral(resourceName: "RemoveFromBasket"))
        button.addTarget(self, action: #selector(removeFromBasket), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    @objc private func removeFromBasket() {
        guard let item = item else { return }
        delegate?.removeItemFromBasket(item)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUserInterface() {
        contentView.addSubview(removeFromBasketButton)
        contentView.addSubview(itemNameLabel)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            removeFromBasketButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            removeFromBasketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            removeFromBasketButton.widthAnchor.constraint(equalToConstant: 40),
            removeFromBasketButton.heightAnchor.constraint(equalToConstant: 40),
            itemNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            itemNameLabel.trailingAnchor.constraint(equalTo: removeFromBasketButton.leadingAnchor, constant: -4),
            itemNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
