import ShoppingList_Application
import ShoppingList_Domain
import XCTest

final class ItemsTests: XCTestCase {
    private var commandBus: CommandBus!
    private var itemQueries: ItemQueries!
    private var itemRepository: ItemRepository!
    private var listRepository: ListRepository!
    private var categoryRepository: ItemsCategoryRepository!

    override func setUp() {
        super.setUp()

        let testContainer = TestContainerProvider.provide()
        self.commandBus = testContainer.resolve(CommandBus.self)
        self.itemQueries = testContainer.resolve(ItemQueries.self)
        self.itemRepository = testContainer.resolve(ItemRepository.self)
        self.listRepository = testContainer.resolve(ListRepository.self)
        self.categoryRepository = testContainer.resolve(ItemsCategoryRepository.self)
    }

    override func tearDown() {
        self.listRepository.removeAll()

        self.categoryRepository = nil
        self.listRepository = nil
        self.itemRepository = nil
        self.itemQueries = nil
        self.commandBus = nil

        super.tearDown()
    }

    func test_can_add_item() {
        let list = List(id: .random(), name: "Test list", accessType: .private, items: [])
        listRepository.add(list)

        commandBus.execute(AddItemCommand("Test item", "", ItemsCategory.default.id, list.id))

        let items = itemRepository.itemsWithState(.toBuy, inListWithId: list.id)
        XCTAssertTrue(items.contains { $0.name == "Test item" })
    }

    func test_can_edit_items_name() {
        let list = List(id: .random(), name: "Test list", accessType: .private, items: [])
        listRepository.add(list)

        let item = Item(id: .random(), name: "Test item", info: "", state: .toBuy, categoryId: nil, listId: list.id)
        itemRepository.addItems([item])

        commandBus.execute(UpdateItemCommand(item.id, "Updated item", "", ItemsCategory.default.id, list.id))

        let items = itemRepository.itemsWithState(.toBuy, inListWithId: list.id)
        XCTAssertTrue(items.contains { $0.name == "Updated item" })
        XCTAssertFalse(items.contains { $0.name == "Test item" })
    }

    func test_can_edit_items_info() {
        let list = List(id: .random(), name: "Test list", accessType: .private, items: [])
        listRepository.add(list)

        let item = Item(id: .random(), name: "Test item", info: "Test item info", state: .toBuy, categoryId: nil, listId: list.id)
        itemRepository.addItems([item])

        commandBus.execute(UpdateItemCommand(item.id, "Test item", "Updated test item info", ItemsCategory.default.id, list.id))

        let items = itemRepository.itemsWithState(.toBuy, inListWithId: list.id)
        XCTAssertTrue(items.contains { $0.info == "Updated test item info" })
        XCTAssertFalse(items.contains { $0.info == "Test item info" })
    }

    func test_can_edit_category() {
        let list = List(id: .random(), name: "Test list", accessType: .private, items: [])
        listRepository.add(list)

        let category = ItemsCategory(id: .random(), name: "Test category")
        categoryRepository.add(category)

        let item = Item(id: .random(), name: "Test item", info: "", state: .toBuy, categoryId: nil, listId: list.id)
        itemRepository.addItems([item])

        commandBus.execute(UpdateItemCommand(item.id, "Test item", "", category.id, list.id))

        let items = itemRepository.itemsWithState(.toBuy, inListWithId: list.id)
        XCTAssertTrue(items.contains { $0.categoryId == category.id })
        XCTAssertFalse(items.contains { $0.categoryId == ItemsCategory.default.id })
    }

    func test_can_edit_list() {
        let firstList = List(id: .random(), name: "First list", accessType: .private, items: [])
        listRepository.add(firstList)

        let secondList = List(id: .random(), name: "Second list", accessType: .private, items: [])
        listRepository.add(secondList)

        let item = Item(id: .random(), name: "Test item", info: "", state: .toBuy, categoryId: nil, listId: firstList.id)
        itemRepository.addItems([item])

        commandBus.execute(UpdateItemCommand(item.id, "Test item", "", ItemsCategory.default.id, secondList.id))

        let itemsInSecondList = itemRepository.itemsWithState(.toBuy, inListWithId: secondList.id)
        XCTAssertTrue(itemsInSecondList.contains { $0.listId == secondList.id })

        let itemsInFirstList = itemRepository.itemsWithState(.toBuy, inListWithId: firstList.id)
        XCTAssertFalse(itemsInFirstList.contains { $0.listId == firstList.id })
    }

    func test_can_remove_item() {
        let list = List(id: .random(), name: "Test list", accessType: .private, items: [])
        listRepository.add(list)

        let item = Item(id: .random(), name: "Test item", info: "", state: .toBuy, categoryId: nil, listId: list.id)
        itemRepository.addItems([item])

        commandBus.execute(RemoveItemsCommand([item]))

        let items = itemRepository.itemsWithState(.toBuy, inListWithId: list.id)
        XCTAssertFalse(items.contains { $0.id == item.id })
    }

    func test_can_move_to_basket() {
        let list = List(id: .random(), name: "Test list", accessType: .private, items: [])
        listRepository.add(list)

        let item = Item(id: .random(), name: "Test item", info: "", state: .toBuy, categoryId: nil, listId: list.id)
        itemRepository.addItems([item])

        commandBus.execute(MoveItemsToBasketCommand([item.id], list.id))

        let itemsToBuy = itemRepository.itemsWithState(.toBuy, inListWithId: list.id)
        XCTAssertFalse(itemsToBuy.contains { $0.id == item.id })

        let itemsInBasket = itemRepository.itemsWithState(.inBasket, inListWithId: list.id)
        XCTAssertTrue(itemsInBasket.contains { $0.id == item.id })
    }

    func test_can_move_few_items_to_basket() {
        let list = List(id: .random(), name: "Test list", accessType: .private, items: [])
        listRepository.add(list)

        let items = [
            Item(id: .random(), name: "Test item 1", info: "", state: .toBuy, categoryId: nil, listId: list.id),
            Item(id: .random(), name: "Test item 2", info: "", state: .toBuy, categoryId: nil, listId: list.id),
            Item(id: .random(), name: "Test item 3", info: "", state: .toBuy, categoryId: nil, listId: list.id)
        ]
        itemRepository.addItems(items)

        commandBus.execute(MoveItemsToBasketCommand(items.map { $0.id }, list.id))

        let itemsToBuy = itemRepository.itemsWithState(.toBuy, inListWithId: list.id)
        XCTAssertEqual(itemsToBuy.count, 0)

        let itemsInBasket = itemRepository.itemsWithState(.inBasket, inListWithId: list.id)
        XCTAssertTrue(itemsInBasket.contains { $0.id == items[0].id })
        XCTAssertTrue(itemsInBasket.contains { $0.id == items[1].id })
        XCTAssertTrue(itemsInBasket.contains { $0.id == items[2].id })
    }

    func test_can_remove_few_items() {
        let list = List(id: .random(), name: "Test list", accessType: .private, items: [])
        listRepository.add(list)

        let items = [
            Item(id: .random(), name: "Test item 1", info: "", state: .toBuy, categoryId: nil, listId: list.id),
            Item(id: .random(), name: "Test item 2", info: "", state: .toBuy, categoryId: nil, listId: list.id),
            Item(id: .random(), name: "Test item 3", info: "", state: .toBuy, categoryId: nil, listId: list.id)
        ]
        itemRepository.addItems(items)

        commandBus.execute(RemoveItemsCommand(items))

        let itemsToBuy = itemRepository.itemsWithState(.toBuy, inListWithId: list.id)
        XCTAssertEqual(itemsToBuy.count, 0)
    }

    func test_can_reorder_items() {
        let list = List(id: .random(), name: "Test list", accessType: .private, items: [])
        listRepository.add(list)

        let items = [
            Item(id: .random(), name: "Test item 1", info: "", state: .toBuy, categoryId: nil, listId: list.id),
            Item(id: .random(), name: "Test item 2", info: "", state: .toBuy, categoryId: nil, listId: list.id),
            Item(id: .random(), name: "Test item 3", info: "", state: .toBuy, categoryId: nil, listId: list.id),
            Item(id: .random(), name: "Test item 4", info: "", state: .toBuy, categoryId: nil, listId: list.id)
        ]
        itemRepository.addItems(items)

        let orderedItems = [items[0], items[2], items[1], items[3]]
        commandBus.execute(SetItemsOrderCommand(orderedItems.map { $0.id }, list.id))

        let itemsToBuy = itemQueries.fetchItemsToBuyFromList(with: list.id)
        XCTAssertEqual(itemsToBuy.map { $0.id }, orderedItems.map { $0.id })
    }

    func test_can_move_item_to_other_category() {
        let list = List(id: .random(), name: "Test list", accessType: .private, items: [])
        listRepository.add(list)

        let item = Item(id: .random(), name: "Test item", info: "", state: .toBuy, categoryId: nil, listId: list.id)
        itemRepository.addItems([item])

        let category = ItemsCategory(id: .random(), name: "Test category")
        categoryRepository.add(category)

        commandBus.execute(UpdateItemCommand(item.id, item.name, item.info ?? "", category.id, item.listId))

        let items = itemRepository.itemsWithState(.toBuy, inListWithId: list.id)
        XCTAssertTrue(items.first?.categoryId == category.id)
    }

    func test_can_move_item_to_other_list() {
        let list1 = List(id: .random(), name: "Test list 1", accessType: .private, items: [])
        listRepository.add(list1)

        let list2 = List(id: .random(), name: "Test list 2", accessType: .private, items: [])
        listRepository.add(list2)

        let item = Item(id: .random(), name: "Test item", info: "", state: .toBuy, categoryId: nil, listId: list1.id)
        itemRepository.addItems([item])

        commandBus.execute(UpdateItemCommand(item.id, item.name, item.info ?? "", item.categoryId, list2.id))

        let itemsInList2 = itemRepository.itemsWithState(.toBuy, inListWithId: list2.id)
        XCTAssertTrue(itemsInList2.contains { $0.id == item.id })

        let itemsInList1 = itemRepository.itemsWithState(.toBuy, inListWithId: list1.id)
        XCTAssertFalse(itemsInList1.contains { $0.id == item.id })
    }
}
