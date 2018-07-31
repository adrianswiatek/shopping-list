import UIKit

class ItemTableViewCell: UITableViewCell {
   
    var item: Item? {
        didSet {
            itemNameLabel.text = item?.name
//            itemDescriptionLabel.text = item?.description
            setItemNameLabelCenterYConstraint()
        }
    }
    
    private func setItemNameLabelCenterYConstraint() {
        let constraint = itemNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        
        if let description = itemDescriptionLabel.text, description != "" {
            constraint.constant = -8
        } else {
            constraint.constant = 0
        }
        
        constraint.isActive = true
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
    
    private lazy var itemDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "Item description"
        label.font = .systemFont(ofSize: 14)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addToBasketButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.setListItemButton(with: #imageLiteral(resourceName: "AddToBasket"))
        button.addTarget(self, action: #selector(addToBasket), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func addToBasket() {
        guard let item = item else { return }
        delegate?.addItemToBasket(item)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUserInterface() {
        contentView.addSubview(addToBasketButton)
        addToBasketButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        addToBasketButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        addToBasketButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addToBasketButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        contentView.addSubview(itemNameLabel)
        itemNameLabel.rightAnchor.constraint(equalTo: addToBasketButton.leftAnchor, constant: 16).isActive = true
        itemNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        
        contentView.addSubview(itemDescriptionLabel)
        itemDescriptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 12).isActive = true
        itemDescriptionLabel.rightAnchor.constraint(equalTo: addToBasketButton.leftAnchor, constant: 16).isActive = true
        itemDescriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
    }
}
