import ShoppingList_Application
import ShoppingList_Domain
import XCTest

final class BasketTests: XCTestCase {
    private var commandBus: CommandBus!
    private var itemRepository: ItemRepository!
    private var listRepository: ListRepository!

    override func setUp() {
        super.setUp()

        let testContainer = TestContainerProvider.provide()
        self.commandBus = testContainer.resolve(CommandBus.self)
        self.itemRepository = testContainer.resolve(ItemRepository.self)
        self.listRepository = testContainer.resolve(ListRepository.self)
    }

    override func tearDown() {
        self.listRepository.removeAll()

        self.listRepository = nil
        self.itemRepository = nil
        self.commandBus = nil

        super.tearDown()
    }

    func test_can_move_item_back_to_the_list() {
        let list = List(id: .random(), name: "List", accessType: .private, items: [])
        listRepository.add(list)

        let item = Item(id: .random(), name: "Item", info: nil, state: .inBasket, categoryId: nil, listId: list.id)
        itemRepository.addItems([item])

        commandBus.execute(MoveItemsToListCommand([item.id], list.id))

        let itemsToBuy = itemRepository.itemsWithState(.toBuy, inListWithId: list.id)
        XCTAssertTrue(itemsToBuy.contains { $0.id == item.id })

        let itemsInBasket = itemRepository.itemsWithState(.inBasket, inListWithId: list.id)
        XCTAssertFalse(itemsInBasket.contains { $0.id == item.id })
    }

    func test_can_move_selected_items_back_to_the_list() {
        let list = List(id: .random(), name: "List", accessType: .private, items: [])
        listRepository.add(list)

        let item1 = Item(id: .random(), name: "Item 1", info: nil, state: .inBasket, categoryId: nil, listId: list.id)
        let item2 = Item(id: .random(), name: "Item 2", info: nil, state: .inBasket, categoryId: nil, listId: list.id)
        let item3 = Item(id: .random(), name: "Item 3", info: nil, state: .inBasket, categoryId: nil, listId: list.id)
        itemRepository.addItems([item1, item2, item3])

        commandBus.execute(MoveItemsToListCommand([item1.id, item2.id], list.id))

        let itemsToBuy = itemRepository.itemsWithState(.toBuy, inListWithId: list.id)
        XCTAssertTrue(itemsToBuy.contains { $0.id == item1.id })
        XCTAssertTrue(itemsToBuy.contains { $0.id == item2.id })
        XCTAssertFalse(itemsToBuy.contains { $0.id == item3.id })

        let itemsInBasket = itemRepository.itemsWithState(.inBasket, inListWithId: list.id)
        XCTAssertFalse(itemsInBasket.contains { $0.id == item1.id })
        XCTAssertFalse(itemsInBasket.contains { $0.id == item2.id })
        XCTAssertTrue(itemsInBasket.contains { $0.id == item3.id })
    }

    func test_can_remove_item() {
        let list = List(id: .random(), name: "List", accessType: .private, items: [])
        listRepository.add(list)

        let item = Item(id: .random(), name: "Item", info: nil, state: .inBasket, categoryId: nil, listId: list.id)
        itemRepository.addItems([item])

        commandBus.execute(RemoveItemsFromBasketCommand([item]))

        let items = itemRepository.itemsWithState(.inBasket, inListWithId: list.id)
        XCTAssertFalse(items.contains { $0.id == item.id })
    }

    func test_can_remove_selected_items() {
        let list = List(id: .random(), name: "List", accessType: .private, items: [])
        listRepository.add(list)

        let item1 = Item(id: .random(), name: "Item 1", info: nil, state: .inBasket, categoryId: nil, listId: list.id)
        let item2 = Item(id: .random(), name: "Item 2", info: nil, state: .inBasket, categoryId: nil, listId: list.id)
        let item3 = Item(id: .random(), name: "Item 3", info: nil, state: .inBasket, categoryId: nil, listId: list.id)
        itemRepository.addItems([item1, item2, item3])

        commandBus.execute(RemoveItemsFromBasketCommand([item1, item2]))

        let items = itemRepository.itemsWithState(.inBasket, inListWithId: list.id)
        XCTAssertFalse(items.contains { $0.id == item1.id })
        XCTAssertFalse(items.contains { $0.id == item2.id })
        XCTAssertTrue(items.contains { $0.id == item3.id })
    }
}
