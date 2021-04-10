import ShoppingList_Application
import ShoppingList_Domain
import ShoppingList_ViewModels
import Combine
import XCTest

final class ListsViewModelTests: XCTestCase {
    private var sut: ListsViewModel!
    private var listRepository: ListRepository!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()

        let container = TestContainerProvider.provide()
        self.sut = container.resolve(ListsViewModel.self)
        self.listRepository = container.resolve(ListRepository.self)
        self.cancellables = []
    }

    override func tearDown() {
        self.listRepository.removeAll()

        self.cancellables = nil
        self.listRepository = nil
        self.sut = nil

        super.tearDown()
    }

    func test_addList_publishes_lists() {
        let expectation = self.expectation(description: "listsPublisher expectation")
        var publishedLists = [ListViewModel]()

        sut.listsPublisher
            .dropFirst()
            .sink {
                publishedLists = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.addList(with: "Test list")

        wait(for: [expectation], timeout: 0.1)

        XCTAssertEqual(publishedLists.count, 1)
        XCTAssertTrue(publishedLists.contains { $0.name == "Test list" })
    }

    func test_updateList_publishes_lists() {
        let list = List(id: .random(), name: "Test list", accessType: .private, items: [])
        listRepository.add(list)

        let expectation = self.expectation(description: "listsPublisher expectation")
        var publishedLists = [ListViewModel]()

        sut.listsPublisher
            .dropFirst()
            .sink {
                publishedLists = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.updateList(with: list.id.toUuid(), name: "Updated test list")

        wait(for: [expectation], timeout: 0.1)

        XCTAssertEqual(publishedLists.count, 1)
        XCTAssertTrue(publishedLists.contains { $0.name == "Updated test list" })
    }

    func test_removeList_publishes_lists() {
        let expectation = self.expectation(description: "listsPublisher expectation")
        expectation.expectedFulfillmentCount = 2
        var publishedLists = [ListViewModel]()

        sut.listsPublisher
            .dropFirst(1)
            .sink {
                publishedLists = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.addList(with: "Test list")

        sut.removeList(with: publishedLists.first!.uuid)

        wait(for: [expectation], timeout: 0.1)

        XCTAssertEqual(publishedLists.count, 0)
    }

    func test_restoreList_publishes_lists() {
        let expectation = self.expectation(description: "listsPublisher expectation")
        expectation.expectedFulfillmentCount = 3
        var publishedLists = [ListViewModel]()

        sut.listsPublisher
            .dropFirst(1)
            .sink {
                publishedLists = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.addList(with: "Test list")
        sut.removeList(with: publishedLists.first!.uuid)

        sut.restoreList()

        wait(for: [expectation], timeout: 0.1)

        XCTAssertEqual(publishedLists.count, 1)
        XCTAssertTrue(publishedLists.contains { $0.name == "Test list" })
    }
}
