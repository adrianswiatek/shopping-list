import ShoppingList_ViewModels
import ShoppingList_Shared
import Combine
import UIKit

public protocol BasketTableViewCellDelegate: AnyObject {
    func basketTableViewCell(
        _ basketTableViewCell: BasketTableViewCell,
        didMoveItemToList item: ItemInBasketViewModel
    )
}

public final class BasketTableViewCell: UITableViewCell {
    public weak var delegate: BasketTableViewCellDelegate?

    public var viewModel: ItemInBasketViewModel? {
        didSet {
            itemNameLabel.text = viewModel?.name
        }
    }

    private let itemNameLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .textPrimary
        $0.font = .systemFont(ofSize: 17)
        $0.numberOfLines = 0
    }
    
    private lazy var moveToListButton: UIButton = configure(.init(type: .system)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setListItemButton(with: #imageLiteral(resourceName: "RemoveFromBasket"))
        $0.addAction(.init { [weak self] _ in
            guard let self = self, let item = self.viewModel else { return }
            self.delegate?.basketTableViewCell(self, didMoveItemToList: item)
        }, for: .touchUpInside)
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }

    private func setupView() {
        let marginsGuide = contentView.layoutMarginsGuide

        contentView.addSubview(moveToListButton)
        NSLayoutConstraint.activate([
            moveToListButton.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),
            moveToListButton.centerYAnchor.constraint(equalTo: marginsGuide.centerYAnchor),
            moveToListButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        contentView.addSubview(itemNameLabel)
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: marginsGuide.topAnchor),
            itemNameLabel.leadingAnchor.constraint(lessThanOrEqualTo: marginsGuide.leadingAnchor),
            itemNameLabel.trailingAnchor.constraint(equalTo: moveToListButton.leadingAnchor),
            itemNameLabel.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor)
        ])
    }
}
