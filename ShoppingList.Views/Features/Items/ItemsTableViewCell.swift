import ShoppingList_Shared
import ShoppingList_ViewModels
import Combine
import UIKit

public protocol ItemsTableViewCellDelegate: AnyObject {
    func itemsTableViewCell(
        _ itemsTableViewCell: ItemsTableViewCell,
        didMoveItemToBasket item: ItemToBuyViewModel
    )

    func itemsTableViewCell(
        _ itemsTableViewCell: ItemsTableViewCell,
        didOpenExternalUrl externalUrl: String
    )
}

public final class ItemsTableViewCell: UITableViewCell {
    public weak var delegate: ItemsTableViewCellDelegate?

    public var viewModel: ItemToBuyViewModel? {
        didSet {
            itemNameLabel.text = viewModel?.name
            itemInfoLabel.text = viewModel?.info
            setItemNameLabelBottomConstraints()
            setItemLinkButtonVisibility()
        }
    }

    private func setItemNameLabelBottomConstraints() {
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

    private func setItemLinkButtonVisibility() {
        if viewModel?.hasExternalUrl == true {
            NSLayoutConstraint.activate(itemLinkButtonConstrants)
            itemNameLabelToAddToBasketButtonConstraint.isActive = false
            itemNameLabelToItemLinkButtonConstraint.isActive = true
            itemLinkButton.isHidden = false
        } else {
            NSLayoutConstraint.deactivate(itemLinkButtonConstrants)
            itemNameLabelToAddToBasketButtonConstraint.isActive = true
            itemNameLabelToItemLinkButtonConstraint.isActive = false
            itemLinkButton.isHidden = true
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

    private lazy var itemLinkButton: UIButton = configure(.init(type: .infoDark)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setListItemButton(with: UIImage(
            systemName: "link.circle",
            withConfiguration: UIImage.SymbolConfiguration(hierarchicalColor: .edit))!
        )
        $0.addAction(.init { [weak self] _ in
            guard let self = self, let externalUrl = self.viewModel?.externalUrl else { return }
            self.delegate?.itemsTableViewCell(self, didOpenExternalUrl: externalUrl)
        }, for: .touchUpInside)
    }

    private lazy var addToBasketButton: UIButton = configure(.init(type: .infoLight)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setListItemButton(with: #imageLiteral(resourceName: "AddToBasket"))
        $0.addAction(.init { [weak self] _ in
            guard let self = self, let item = self.viewModel else { return }
            self.delegate?.itemsTableViewCell(self, didMoveItemToBasket: item)
        }, for: .touchUpInside)
    }

    private lazy var itemLinkButtonConstrants: [NSLayoutConstraint] = [
        itemLinkButton.trailingAnchor.constraint(equalTo: addToBasketButton.leadingAnchor),
        itemLinkButton.heightAnchor.constraint(equalTo: addToBasketButton.heightAnchor),
        itemLinkButton.widthAnchor.constraint(equalTo: addToBasketButton.widthAnchor),
        itemLinkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ]

    private var itemNameLabelTopConstraint: NSLayoutConstraint!
    private var itemNameLabelCenterYConstraint: NSLayoutConstraint!
    private var itemNameLabelToAddToBasketButtonConstraint: NSLayoutConstraint!
    private var itemNameLabelToItemLinkButtonConstraint: NSLayoutConstraint!

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }

    private func setupView() {
        contentView.addSubview(addToBasketButton)
        NSLayoutConstraint.activate([
            addToBasketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addToBasketButton.heightAnchor.constraint(equalToConstant: 40),
            addToBasketButton.widthAnchor.constraint(equalTo: addToBasketButton.heightAnchor),
            addToBasketButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        contentView.addSubview(itemLinkButton)

        contentView.addSubview(itemNameLabel)
        NSLayoutConstraint.activate([
            itemNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])

        contentView.addSubview(itemInfoLabel)
        NSLayoutConstraint.activate([
            itemInfoLabel.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
            itemInfoLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 2),
            itemInfoLabel.trailingAnchor.constraint(equalTo: itemNameLabel.trailingAnchor),
            itemInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])

        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

        setupItemNameLabelVariableConstraints()
    }

    private func setupItemNameLabelVariableConstraints() {
        itemNameLabelTopConstraint =
            itemNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)

        itemNameLabelCenterYConstraint =
            itemNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

        itemNameLabelToAddToBasketButtonConstraint =
            itemNameLabel.trailingAnchor.constraint(equalTo: addToBasketButton.leadingAnchor)

        itemNameLabelToItemLinkButtonConstraint =
            itemNameLabel.trailingAnchor.constraint(equalTo: itemLinkButton.leadingAnchor)

        itemNameLabelTopConstraint.isActive = false
        itemNameLabelCenterYConstraint.isActive = true

        itemNameLabelToAddToBasketButtonConstraint.isActive = true
        itemNameLabelToItemLinkButtonConstraint.isActive = false
    }
}
