import ShoppingList_Application
import ShoppingList_Domain
import ShoppingList_ViewModels
import Combine
import XCTest

final class BasketViewModelTests: XCTestCase {
    private var sut: BasketViewModel!
    private var list: ListViewModel!
    private var itemRepository: ItemRepository!
    private var listRepository: ListRepository!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()

        let container = TestContainerProvider.provide()

        let list = List(id: .random(), name: "Test list", accessType: .private, items: [])
        self.list = ListViewModel(list, .init())

        self.sut = container.resolve(BasketViewModel.self)
        self.sut.setList(self.list)

        self.itemRepository = container.resolve(ItemRepository.self)
        self.listRepository = container.resolve(ListRepository.self)
        self.listRepository.add(list)
        self.cancellables = []
    }

    override func tearDown() {
        self.itemRepository.removeAll()
        self.listRepository.removeAll()

        self.cancellables = nil
        self.listRepository = nil
        self.itemRepository = nil
        self.list = nil
        self.sut = nil

        super.tearDown()
    }

    func test_removeItems_publishes_items() {
        let item1 = testItem(withName: "Test item 1")
        let item2 = testItem(withName: "Test item 2")
        itemRepository.addItems([item1, item2])

        let expectation = self.expectation(description: "itemsPublisher expectation")
        expectation.expectedFulfillmentCount = 2

        var publishedItems = [ItemInBasketViewModel]()

        sut.itemsPublisher
            .dropFirst()
            .sink {
                publishedItems = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.fetchItems()

        sut.removeItems(with: [item1.id.toUuid()])

        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(publishedItems.contains { $0.uuid == item2.id.toUuid() })
        XCTAssertFalse(publishedItems.contains { $0.uuid == item1.id.toUuid() })
    }

    func test_removeAllItems_publishes_items() {
        let item = testItem(withName: "Test item")
        itemRepository.addItems([item])

        let expectation = self.expectation(description: "itemsPublisher expectation")
        expectation.expectedFulfillmentCount = 2

        var publishedItems = [ItemInBasketViewModel]()

        sut.itemsPublisher
            .dropFirst()
            .sink {
                publishedItems = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.fetchItems()

        sut.removeAllItems()

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(publishedItems.count, 0)
    }

    func test_moveToListItems_publishes_items() {
        let item1 = testItem(withName: "Test item 1")
        let item2 = testItem(withName: "Test item 2")
        itemRepository.addItems([item1, item2])

        let expectation = self.expectation(description: "itemsPublisher expectation")
        expectation.expectedFulfillmentCount = 2

        var publishedItems = [ItemInBasketViewModel]()

        sut.itemsPublisher
            .dropFirst()
            .sink {
                publishedItems = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.fetchItems()

        sut.moveToListItems(with: [item1.id.toUuid()])

        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(publishedItems.contains { $0.uuid == item2.id.toUuid() })
        XCTAssertFalse(publishedItems.contains { $0.uuid == item1.id.toUuid() })
    }

    func test_moveAllItemsToList_publishes_items() {
        let item = testItem(withName: "Test item")
        itemRepository.addItems([item])

        let expectation = self.expectation(description: "itemsPublisher expectation")
        expectation.expectedFulfillmentCount = 2

        var publishedItems = [ItemInBasketViewModel]()

        sut.itemsPublisher
            .dropFirst()
            .sink {
                publishedItems = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.fetchItems()

        sut.moveAllItemsToList()

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(publishedItems.count, 0)
    }

    func test_restoreItem_publishes_items() {
        let item = testItem(withName: "Test item")
        itemRepository.addItems([item])

        let expectation = self.expectation(description: "itemsPublisher expectation")
        expectation.expectedFulfillmentCount = 3

        var publishedItems = [ItemInBasketViewModel]()

        sut.itemsPublisher
            .dropFirst()
            .sink {
                publishedItems = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.fetchItems()
        sut.removeItems(with: [item.id.toUuid()])

        sut.restoreItem()

        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(publishedItems.contains { $0.uuid == item.id.toUuid() })
    }

    func test_setState_publishes_state() {
        let expectation = self.expectation(description: "itemsPublisher expectation")
        var publishedState: BasketViewModel.State?

        sut.statePublisher
            .dropFirst()
            .sink {
                publishedState = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.setState(.editing)

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(BasketViewModel.State.editing, publishedState)
    }

    private func testItem(withName itemName: String) -> Item {
        Item(
            id: .random(),
            name: itemName,
            info: nil,
            state: .inBasket,
            categoryId: nil,
            listId: .fromUuid(list.uuid)
        )
    }
}
