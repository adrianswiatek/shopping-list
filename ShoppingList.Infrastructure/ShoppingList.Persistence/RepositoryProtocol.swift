import ShoppingList_Application
import ShoppingList_Domain

protocol RepositoryProtocol: ListRepository, ItemsCategoryRepository, ItemRepository {
    func setItemsOrder(_ items: [Item], in list: List, forState state: ItemState)
    func save()
}
