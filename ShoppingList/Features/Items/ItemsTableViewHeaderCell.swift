import UIKit

final class ItemsTableViewHeaderCell: UIView {
    var category: Category? {
        didSet {
            label.text = category?.name
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = UIColor(white: 0.2, alpha: 1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserInterace()
    }
    
    private func setupUserInterace() {
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
