import UIKit

class BasketTableViewCell: UITableViewCell {

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
        label.lineBreakMode = .byTruncatingTail
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUserInterface() {
        contentView.addSubview(removeFromBasketButton)
        removeFromBasketButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        removeFromBasketButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        removeFromBasketButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        removeFromBasketButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        contentView.addSubview(itemNameLabel)
        itemNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        itemNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        itemNameLabel.rightAnchor.constraint(equalTo: removeFromBasketButton.leftAnchor, constant: 16).isActive = true
    }
}
