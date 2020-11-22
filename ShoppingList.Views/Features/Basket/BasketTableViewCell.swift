import ShoppingList_Domain
import ShoppingList_Shared
import UIKit

public final class BasketTableViewCell: UITableViewCell {
    public var item: Item? {
        didSet {
            itemNameLabel.text = item?.name
        }
    }
    
    public var delegate: RemoveFromBasketDelegate?

    private let itemNameLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .textPrimary
        $0.text = "Item name"
        $0.font = .systemFont(ofSize: 17)
        $0.numberOfLines = 0
    }
    
    private lazy var removeFromBasketButton: UIButton = configure(.init(type: .system)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setListItemButton(with: #imageLiteral(resourceName: "RemoveFromBasket"))
        $0.addTarget(self, action: #selector(removeFromBasket), for: .touchUpInside)
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
    
    private func setupView() {
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

    @objc
    private func removeFromBasket() {
        guard let item = item else { return }
        delegate?.removeItemFromBasket(item)
    }
}
