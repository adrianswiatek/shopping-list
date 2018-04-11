import UIKit

extension UIButton {
    func setToItemButton(with image: UIImage) {
        self.layer.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        
        self.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        self.tintColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
    }
}
