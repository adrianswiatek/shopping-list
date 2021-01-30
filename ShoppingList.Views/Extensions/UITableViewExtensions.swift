import UIKit

extension UITableView {
    public func setBackgroundLabel(_ text: String) {
        let label = UILabel(frame: bounds)
        label.text = text
        label.textColor = .textPrimary
        label.textAlignment = .center
        backgroundView = label
    }

    public func registerCell(ofType type: UITableViewCell.Type) {
        registerCells(ofTypes: [type])
    }

    public func registerCells(ofTypes types: [UITableViewCell.Type]) {
        for cell in types {
            register(cell, forCellReuseIdentifier: cell.identifier)
        }
    }
}
