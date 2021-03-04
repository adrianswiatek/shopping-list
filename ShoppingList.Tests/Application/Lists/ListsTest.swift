import ShoppingList_Application
import ShoppingList_Domain
import XCTest

final class ListsTests: XCTestCase {
    private var commandBus: CommandBus!
    private var eventBus: EventBus!
    private var listRepository: ListRepository!

    override func setUp() {
        super.setUp()

        let testContainer = TestContainerProvider.provide()
        self.commandBus = testContainer.resolve(CommandBus.self)
        self.eventBus = testContainer.resolve(EventBus.self)
        self.listRepository = testContainer.resolve(ListRepository.self)
    }

    override func tearDown() {
        self.listRepository.removeAll()

        self.listRepository = nil
        self.eventBus = nil
        self.commandBus = nil

        super.tearDown()
    }

    func test_can_add_list() {
        let listName = "Test List"

        commandBus.execute(AddListCommand(listName))

        let lists = listRepository.allLists()
        XCTAssertTrue(lists.contains { $0.name == listName })
    }

    func test_can_remove_list() {
        let listId: Id<List> = .random()
        let list = List(id: listId, name: "Test List", accessType: .private, items: [])

        listRepository.add(list)
        XCTAssertTrue(listRepository.allLists().contains { $0.id == listId })

        commandBus.execute(RemoveListCommand(list))

        XCTAssertFalse(listRepository.allLists().contains { $0.id == listId })
    }

    func test_can_edit_list() {
        let initialListName = "Initial List Name"
        let finalListName = "Final List Name"
        let list = List(id: .random(), name: initialListName, accessType: .private, items: [])

        listRepository.add(list)
        XCTAssertTrue(listRepository.allLists().contains { $0.name == initialListName })

        commandBus.execute(UpdateListCommand(list.id, finalListName))

        let lists = listRepository.allLists()
        XCTAssertTrue(lists.contains { $0.name == finalListName })
        XCTAssertFalse(lists.contains { $0.name == initialListName })
    }
}
