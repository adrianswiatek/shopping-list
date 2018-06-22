import UIKit

class ListsTableViewCell: UITableViewCell {
    
    var list: List? {
        didSet {
            guard let list = list else { return }
            nameLabel.text = list.name
            accessTypeLabel.text = list.accessType.rawValue
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 18)
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
        contentView.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
