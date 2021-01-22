import ShoppingList_ViewModels
import ShoppingList_Shared
import Combine
import UIKit

public final class BasketTableViewCell: UITableViewCell {
    public var moveToListTapped: AnyPublisher<ItemInBasketViewModel, Never> {
        moveToListSubject.eraseToAnyPublisher()
    }

    public var viewModel: ItemInBasketViewModel? {
        didSet {
            itemNameLabel.text = viewModel?.name
        }
    }

    private let itemNameLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .textPrimary
        $0.text = "Item name"
        $0.font = .systemFont(ofSize: 17)
        $0.numberOfLines = 0
    }
    
    private lazy var moveToListButton: UIButton = configure(.init(type: .system)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setListItemButton(with: #imageLiteral(resourceName: "RemoveFromBasket"))
        $0.addAction(.init { [weak self] _ in
            guard let item = self?.viewModel else { return }
            self?.moveToListSubject.send(item)
        }, for: .touchUpInside)
    }

    private let moveToListSubject: PassthroughSubject<ItemInBasketViewModel, Never>
    private var moveToListCancellable: AnyCancellable?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.moveToListSubject = .init()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }

    public func setCancellable(_ cancellable: AnyCancellable?) {
        moveToListCancellable = cancellable
    }

    private func setupView() {
        contentView.addSubview(moveToListButton)
        NSLayoutConstraint.activate([
            moveToListButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            moveToListButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            moveToListButton.widthAnchor.constraint(equalToConstant: 40),
            moveToListButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        contentView.addSubview(itemNameLabel)
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            itemNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            itemNameLabel.trailingAnchor.constraint(equalTo: moveToListButton.leadingAnchor, constant: -4)
        ])
    }
}
