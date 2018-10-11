import UIKit

class ItemsTableViewCell: UITableViewCell {
   
    weak var delegate: AddToBasketDelegate?
    
    var item: Item? {
        didSet {
            itemNameLabel.text = item?.name
            itemInfoLabel.text = item?.info
            setItemNameLabelBottomConstraint()
        }
    }
    
    private func setItemNameLabelBottomConstraint() {
        if itemInfoLabel.text == nil || itemInfoLabel.text == "" {
            itemNameLabelTopConstraint.isActive = false
            itemNameLabelCenterYConstraint.isActive = true
            itemInfoLabel.alpha = 0
        } else {
            itemNameLabelTopConstraint.isActive = true
            itemNameLabelCenterYConstraint.isActive = false
            itemInfoLabel.alpha = 1
        }
    }
    
    private lazy var itemNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var itemInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
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
    
    private var itemNameLabelTopConstraint: NSLayoutConstraint!
    private var itemNameLabelCenterYConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUserInterface() {
        contentView.addSubview(addToBasketButton)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(itemInfoLabel)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            addToBasketButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addToBasketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addToBasketButton.heightAnchor.constraint(equalToConstant: 40),
            addToBasketButton.widthAnchor.constraint(equalTo: addToBasketButton.heightAnchor),
            itemNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemNameLabel.trailingAnchor.constraint(equalTo: addToBasketButton.leadingAnchor, constant: -4),
            itemInfoLabel.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
            itemInfoLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 2),
            itemInfoLabel.trailingAnchor.constraint(equalTo: itemNameLabel.trailingAnchor),
            itemInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
        
        itemNameLabelTopConstraint = itemNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        itemNameLabelTopConstraint.isActive = false
        
        itemNameLabelCenterYConstraint = itemNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        itemNameLabelCenterYConstraint.isActive = true
    }
}
