import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var addToBasketButton: UIButton!
    
    private var item: Item?
    
    private weak var delegate: AddToBasketDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addToBasketButton.setToItemButton(with: #imageLiteral(resourceName: "AddToBasket"))
    }
    
    func initialize(item: Item, delegate: AddToBasketDelegate) {
        self.item = item
        self.delegate = delegate
    }
    
    @IBAction func addToBasketTapped(_ sender: UIButton) {
        guard let item = item else { return }
        delegate?.addItemToBasket(item)
    }
}
