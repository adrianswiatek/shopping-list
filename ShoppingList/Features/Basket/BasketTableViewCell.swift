import UIKit

class BasketTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var removeFromBasketButton: UIButton!
    
    private var item: Item?
    
    private weak var delegate: RemoveFromBasketDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        removeFromBasketButton.setToItemButton(with: #imageLiteral(resourceName: "RemoveFromBasket"))
    }
    
    func initialize(item: Item, delegate: RemoveFromBasketDelegate) {
        self.item = item
        self.delegate = delegate
    }
    
    @IBAction func removeFromBasketTapped(_ sender: UIButton) {
        guard let item = item else { return }
        delegate?.removeItemFromBasket(item)
    }
}
