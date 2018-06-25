import UIKit

class ListsTableViewCell: UITableViewCell {
    
    var list: List? {
        didSet {
            guard let list = list else { return }
            nameLabel.text = list.name
            accessTypeLabel.text = list.accessType.rawValue
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
        formatter.dateStyle = .short
        
        return formatter.string(from: date)
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 18)
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
        imageView.image = #imageLiteral(resourceName: "Locked").withRenderingMode(.alwaysTemplate)
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
        accessTypeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        accessTypeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        accessTypeView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        accessTypeView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        accessTypeView.addSubview(accessTypeLabel)
        accessTypeLabel.trailingAnchor.constraint(equalTo: accessTypeView.trailingAnchor).isActive = true
        accessTypeLabel.bottomAnchor.constraint(equalTo: accessTypeView.bottomAnchor).isActive = true
        
        accessTypeView.addSubview(accessTypeImageView)
        accessTypeImageView.centerXAnchor.constraint(equalTo: accessTypeLabel.centerXAnchor).isActive = true
        accessTypeImageView.bottomAnchor.constraint(equalTo: accessTypeLabel.topAnchor).isActive = true
        accessTypeImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        accessTypeImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: accessTypeView.leadingAnchor).isActive = true
        
        contentView.addSubview(numberOfItemsLabel)
        numberOfItemsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        numberOfItemsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 6).isActive = true
        
        contentView.addSubview(numberOfItemsValueLabel)
        numberOfItemsValueLabel.leadingAnchor.constraint(equalTo: numberOfItemsLabel.trailingAnchor, constant: 4).isActive = true
        numberOfItemsValueLabel.centerYAnchor.constraint(equalTo: numberOfItemsLabel.centerYAnchor).isActive = true
        
        contentView.addSubview(updateDateLabel)
        updateDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        updateDateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 24).isActive = true
        updateDateLabel.widthAnchor.constraint(equalTo: numberOfItemsLabel.widthAnchor).isActive = false
        
        contentView.addSubview(updateDateValueLabel)
        updateDateValueLabel.leadingAnchor.constraint(equalTo: updateDateLabel.trailingAnchor, constant: 4).isActive = true
        updateDateValueLabel.centerYAnchor.constraint(equalTo: updateDateLabel.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
