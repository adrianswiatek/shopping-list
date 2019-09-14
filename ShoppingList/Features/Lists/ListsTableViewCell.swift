import UIKit

final class ListsTableViewCell: UITableViewCell {
    var list: List? {
        didSet {
            guard let list = list else { return }
            nameLabel.text = list.name
            accessTypeImageView.image = (list.accessType == .private ? #imageLiteral(resourceName: "Locked") : #imageLiteral(resourceName: "Shared")).withRenderingMode(.alwaysTemplate)
            accessTypeLabel.text = list.accessType.description
            numberOfItemsValueLabel.text = String(list.getNumberOfItemsToBuy())
            updateDateValueLabel.text = getFormatted(date: list.updateDate)
        }
    }
    
    private func getFormatted(date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return formatter.string(from: date)
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberOfItemsLabel: UILabel = {
        let label = UILabel()
        label.text = "Items to buy:"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberOfItemsValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let updateDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Updated:"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let updateDateValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let accessTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let accessTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let accessTypeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        setupUserInterface()
    }
    
    private func setupUserInterface() {
        contentView.addSubview(accessTypeView)
        accessTypeView.addSubview(accessTypeLabel)
        accessTypeView.addSubview(accessTypeImageView)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(numberOfItemsLabel)
        contentView.addSubview(numberOfItemsValueLabel)
        contentView.addSubview(updateDateLabel)
        contentView.addSubview(updateDateValueLabel)
        
        NSLayoutConstraint.activate([
            accessTypeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            accessTypeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            accessTypeView.heightAnchor.constraint(equalToConstant: 48),
            accessTypeView.widthAnchor.constraint(equalToConstant: 48),
            accessTypeLabel.trailingAnchor.constraint(equalTo: accessTypeView.trailingAnchor),
            accessTypeLabel.bottomAnchor.constraint(equalTo: accessTypeView.bottomAnchor),
            accessTypeImageView.centerXAnchor.constraint(equalTo: accessTypeLabel.centerXAnchor),
            accessTypeImageView.bottomAnchor.constraint(equalTo: accessTypeLabel.topAnchor),
            accessTypeImageView.heightAnchor.constraint(equalToConstant: 24),
            accessTypeImageView.widthAnchor.constraint(equalToConstant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: accessTypeView.leadingAnchor, constant: -12),
            numberOfItemsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            numberOfItemsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            numberOfItemsValueLabel.leadingAnchor.constraint(equalTo: numberOfItemsLabel.trailingAnchor, constant: 4),
            numberOfItemsValueLabel.centerYAnchor.constraint(equalTo: numberOfItemsLabel.centerYAnchor),
            updateDateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            updateDateLabel.topAnchor.constraint(equalTo: numberOfItemsLabel.bottomAnchor),
            updateDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            updateDateLabel.widthAnchor.constraint(equalTo: numberOfItemsLabel.widthAnchor),
            updateDateValueLabel.leadingAnchor.constraint(equalTo: updateDateLabel.trailingAnchor, constant: 4),
            updateDateValueLabel.centerYAnchor.constraint(equalTo: updateDateLabel.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
