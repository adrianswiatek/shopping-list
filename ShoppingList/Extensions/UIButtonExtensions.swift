import UIKit

extension UIButton {
    func setListItemButton(with image: UIImage) {
        self.setImage(image.withRenderingMode(.alwaysTemplate), for: UIControl.State.normal)
        self.tintColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
    }
}
