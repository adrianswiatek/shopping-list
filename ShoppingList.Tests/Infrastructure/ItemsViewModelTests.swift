import ShoppingList_Application
import ShoppingList_Domain
import ShoppingList_ViewModels
import Combine
import XCTest

final class ItemsViewModelTests: XCTestCase {
    private var sut: ItemsViewModel!
    private var list: ListViewModel!
    private var itemRepository: ItemRepository!
    private var listRepository: ListRepository!
    private var categoryRepository: ItemsCategoryRepository!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()

        let container = TestContainerProvider.provide()
        container.resolve(CommandBus.self).execute(AddDefaultItemsCategoryCommand())

        let list = List(id: .random(), name: "Test list", accessType: .private, items: [])
        self.list = ListViewModel(list, .init())

        self.sut = container.resolve(ItemsViewModel.self)
        self.sut.setList(self.list)

        self.itemRepository = container.resolve(ItemRepository.self)

        self.listRepository = container.resolve(ListRepository.self)
        self.listRepository.add(list)

        self.categoryRepository = container.resolve(ItemsCategoryRepository.self)
        self.cancellables = []
    }

    override func tearDown() {
        self.itemRepository.removeAll()
        self.listRepository.removeAll()
        self.categoryRepository.removeAll()

        self.cancellables = nil
        self.categoryRepository = nil
        self.listRepository = nil
        self.itemRepository = nil
        self.sut = nil

        super.tearDown()
    }

    func test_addItem_publishes_sections() {
        let expectation = self.expectation(description: "sectionsPublisher expectation")
        expectation.expectedFulfillmentCount = 2
        var publishedSections = [ItemsSectionViewModel]()

        sut.sectionsPublisher
            .dropFirst()
            .sink {
                publishedSections = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.addItem(with: "Test item")

        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(publishedSections.flatMap { $0.items }.contains { $0.name == "Test item" })
    }

    func test_addToBasketItems_publishes_sections() {
        let item1 = itemWithName("Test name 1")
        let item2 = itemWithName("Test name 2")
        itemRepository.addItems([item1, item2])
        sut.fetchItems()

        let expectation = self.expectation(description: "sectionsPublisher expectation")
        expectation.expectedFulfillmentCount = 2
        var publishedSections = [ItemsSectionViewModel]()

        sut.sectionsPublisher
            .dropFirst()
            .sink {
                publishedSections = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.addToBasketItems(with: [item1.id.toUuid()])

        wait(for: [expectation], timeout: 0.1)

        let publishedItems = publishedSections.flatMap { $0.items }
        XCTAssertTrue(publishedItems.contains { $0.uuid == item2.id.toUuid() })
        XCTAssertFalse(publishedItems.contains { $0.uuid == item1.id.toUuid() })
    }

    func test_addToBasketAllItems_publishes_sections() {
        let item1 = itemWithName("Test name 1")
        let item2 = itemWithName("Test name 2")
        itemRepository.addItems([item1, item2])
        sut.fetchItems()

        let expectation = self.expectation(description: "sectionsPublisher expectation")
        expectation.expectedFulfillmentCount = 2
        var publishedSections = [ItemsSectionViewModel]()

        sut.sectionsPublisher
            .dropFirst()
            .sink {
                publishedSections = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.addToBasketAllItems()

        wait(for: [expectation], timeout: 0.1)

        let publishedItems = publishedSections.flatMap { $0.items }
        XCTAssertFalse(publishedItems.contains { $0.uuid == item2.id.toUuid() })
        XCTAssertFalse(publishedItems.contains { $0.uuid == item1.id.toUuid() })
    }

    func test_removeItems_publishes_sections() {
        let item1 = itemWithName("Test name 1")
        let item2 = itemWithName("Test name 2")
        itemRepository.addItems([item1, item2])
        sut.fetchItems()

        let expectation = self.expectation(description: "sectionsPublisher expectation")
        expectation.expectedFulfillmentCount = 2
        var publishedSections = [ItemsSectionViewModel]()

        sut.sectionsPublisher
            .dropFirst()
            .sink {
                publishedSections = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.removeItems(with: [item1.id.toUuid()])

        wait(for: [expectation], timeout: 0.1)

        let publishedItems = publishedSections.flatMap { $0.items }
        XCTAssertTrue(publishedItems.contains { $0.uuid == item2.id.toUuid() })
        XCTAssertFalse(publishedItems.contains { $0.uuid == item1.id.toUuid() })
    }

    func test_removeAllItems_publishes_sections() {
        let item1 = itemWithName("Test name 1")
        let item2 = itemWithName("Test name 2")
        itemRepository.addItems([item1, item2])
        sut.fetchItems()

        let expectation = self.expectation(description: "sectionsPublisher expectation")
        expectation.expectedFulfillmentCount = 2
        var publishedSections = [ItemsSectionViewModel]()

        sut.sectionsPublisher
            .dropFirst()
            .sink {
                publishedSections = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.removeAllItems()

        wait(for: [expectation], timeout: 0.1)
        let publishedItems = publishedSections.flatMap { $0.items }
        XCTAssertFalse(publishedItems.contains { $0.uuid == item2.id.toUuid() })
        XCTAssertFalse(publishedItems.contains { $0.uuid == item1.id.toUuid() })
    }

    private func itemWithName(_ name: String) -> Item {
        Item(
            id: .random(),
            name: name,
            info: nil,
            state: .toBuy,
            categoryId: nil,
            listId: .fromUuid(list.uuid)
        )
    }
}
