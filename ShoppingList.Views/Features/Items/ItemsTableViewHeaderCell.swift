import ShoppingList_Domain
import ShoppingList_Shared
import UIKit

public final class ItemsTableViewHeaderCell: UIView {
    public var category: ItemsCategory? {
        didSet {
            label.text = category?.name
        }
    }
    
    private let label: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .textSecondary
        $0.numberOfLines = 0
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
    
    private func setupView() {
        backgroundColor = .header
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
}
