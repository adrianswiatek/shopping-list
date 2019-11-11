import UIKit

extension UIButton {
    func setListItemButton(with image: UIImage) {
        self.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        self.tintColor = .textPrimary
    }
}
