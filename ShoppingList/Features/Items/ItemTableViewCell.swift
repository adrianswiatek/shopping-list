import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var addToBasketButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addToBasketButton.layer.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        addToBasketButton.layer.borderWidth = 1
        addToBasketButton.layer.cornerRadius = 20
        
        addToBasketButton.setImage(#imageLiteral(resourceName: "AddToBasket").withRenderingMode(.alwaysTemplate), for: .normal)
        addToBasketButton.tintColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
    }
    
    @IBAction func addToBasketTapped(_ sender: UIButton) {
        addToBasketButton.layer.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
    }
}
