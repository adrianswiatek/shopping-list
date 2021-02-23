import UIKit

extension UITableView {
    public func setBackgroundLabel(_ text: String) {
        let label = UILabel(frame: bounds)
        label.text = text
        label.textColor = .textPrimary
        label.textAlignment = .center
        backgroundView = label
    }

    public func registerCell(_ type: UITableViewCell.Type) {
        registerCells([type])
    }

    public func registerCells(_ types: [UITableViewCell.Type]) {
        for cell in types {
            register(cell, forCellReuseIdentifier: cell.identifier)
        }
    }
}
