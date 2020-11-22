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
        label.textColor = .textPrimary
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
        NSLayoutConstraint.activate([
            removeFromBasketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            removeFromBasketButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            removeFromBasketButton.widthAnchor.constraint(equalToConstant: 40),
            removeFromBasketButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        contentView.addSubview(itemNameLabel)
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            itemNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            itemNameLabel.trailingAnchor.constraint(equalTo: removeFromBasketButton.leadingAnchor, constant: -4)
        ])

        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
    }
}
