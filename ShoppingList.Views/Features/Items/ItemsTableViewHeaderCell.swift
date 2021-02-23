import ShoppingList_Domain
import ShoppingList_Shared
import UIKit

public final class ItemsTableViewHeaderCell: UIView {
    private let label: UILabel =
        configure(.init()) {
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

    public func setTitle(_ title: String) {
        label.text = title
    }
    
    private func setupView() {
        backgroundColor = .header

        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}
