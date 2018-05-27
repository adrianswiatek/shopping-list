import UIKit

class ItemTableViewCell: UITableViewCell {
   
    var item: Item? {
        didSet {
            itemNameLabel.text = item?.name
        }
    }
    
    weak var delegate: AddToBasketDelegate?
    
    private lazy var itemNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        label.text = "Item name"
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addToBasketButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.setListItemButton(with: #imageLiteral(resourceName: "Basket"))
        button.addTarget(self, action: #selector(addToBasket), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func addToBasket() {
        guard let item = item else { return }
        delegate?.addItemToBasket(item)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(addToBasketButton)
        addToBasketButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addToBasketButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        addToBasketButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addToBasketButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(itemNameLabel)
        itemNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        itemNameLabel.rightAnchor.constraint(equalTo: addToBasketButton.leftAnchor, constant: 16).isActive = true
        itemNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    }
}
