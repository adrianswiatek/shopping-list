import ShoppingList_Shared
import ShoppingList_ViewModels

import Combine
import UIKit

public final class ItemsTableViewCell: UITableViewCell {
    public var moveToBasketTapped: AnyPublisher<ItemToBuyViewModel, Never> {
        moveToBasketSubject.eraseToAnyPublisher()
    }
    
    public var viewModel: ItemToBuyViewModel? {
        didSet {
            itemNameLabel.text = viewModel?.name
            itemInfoLabel.text = viewModel?.info
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
    
    private let itemNameLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .textPrimary
        $0.font = .systemFont(ofSize: 17)
        $0.numberOfLines = 0
    }
    
    private let itemInfoLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .textSecondary
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    private lazy var addToBasketButton: UIButton = configure(.init(type: .infoLight)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setListItemButton(with: #imageLiteral(resourceName: "AddToBasket"))
        $0.addAction(.init { [weak self] _ in
            guard let item = self?.viewModel else { return }
            self?.moveToBasketSubject.send(item)
        }, for: .touchUpInside)
    }

    private var itemNameLabelTopConstraint: NSLayoutConstraint!
    private var itemNameLabelCenterYConstraint: NSLayoutConstraint!

    private let moveToBasketSubject: PassthroughSubject<ItemToBuyViewModel, Never>
    private var moveToBasketCancellable: AnyCancellable?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.moveToBasketSubject = .init()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }

    public func setCancellable(_ cancellable: AnyCancellable?) {
        moveToBasketCancellable = cancellable
    }
    
    private func setupView() {
        contentView.addSubview(addToBasketButton)
        NSLayoutConstraint.activate([
            addToBasketButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addToBasketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addToBasketButton.heightAnchor.constraint(equalToConstant: 40),
            addToBasketButton.widthAnchor.constraint(equalTo: addToBasketButton.heightAnchor)
        ])

        contentView.addSubview(itemNameLabel)
        NSLayoutConstraint.activate([
            itemNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemNameLabel.trailingAnchor.constraint(equalTo: addToBasketButton.leadingAnchor, constant: -4)
        ])

        contentView.addSubview(itemInfoLabel)
        NSLayoutConstraint.activate([
            itemInfoLabel.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
            itemInfoLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 2),
            itemInfoLabel.trailingAnchor.constraint(equalTo: itemNameLabel.trailingAnchor),
            itemInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])

        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

        itemNameLabelTopConstraint = itemNameLabel.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: 10
        )
        itemNameLabelTopConstraint.isActive = false
        
        itemNameLabelCenterYConstraint = itemNameLabel.centerYAnchor.constraint(
            equalTo: contentView.centerYAnchor
        )
        itemNameLabelCenterYConstraint.isActive = true
    }
}
