import ShoppingList_Application
import ShoppingList_Domain
import XCTest

final class ItemsCategoryTests: XCTestCase {
    private var commandBus: CommandBus!
    private var eventBus: EventBus!
    private var categoryRepository: ItemsCategoryRepository!
    private var categoryQueries: ItemsCategoryQueries!
    private var listRepository: ListRepository!
    private var itemRepository: ItemRepository!

    override func setUp() {
        super.setUp()

        let container = TestContainerProvider.provide()
        self.commandBus = container.resolve(CommandBus.self)
        self.eventBus = container.resolve(EventBus.self)
        self.categoryRepository = container.resolve(ItemsCategoryRepository.self)
        self.categoryQueries = container.resolve(ItemsCategoryQueries.self)
        self.listRepository = container.resolve(ListRepository.self)
        self.itemRepository = container.resolve(ItemRepository.self)
    }

    override func tearDown() {
        self.categoryRepository.removeAll()

        self.itemRepository = nil
        self.listRepository = nil
        self.categoryQueries = nil
        self.categoryRepository = nil
        self.eventBus = nil
        self.commandBus = nil

        super.tearDown()
    }

    func test_can_add_category() {
        let categoryName = "Test category"

        commandBus.execute(AddItemsCategoryCommand(categoryName))

        let categories = categoryRepository.allCategories()
        XCTAssertTrue(categories.contains { $0.name == categoryName })
    }

    func test_cannot_add_categeory_with_name_that_already_exists() {
        let category = ItemsCategory(id: .random(), name: "Test category")
        categoryRepository.add(category)

        commandBus.execute(AddItemsCategoryCommand(category.name))

        let categories = categoryRepository.allCategories()
        XCTAssertEqual(categories.count, 1)
    }

    func test_can_remove_empty_category() {
        let category = ItemsCategory(id: .random(), name: "Test category")
        categoryRepository.add(category)

        commandBus.execute(RemoveItemsCategoryCommand(category))

        let categories = categoryRepository.allCategories()
        XCTAssertFalse(categories.contains { $0.id == category.id })
    }

    func test_can_remove_category_with_items_moving_those_items_to_default_category() {
        let category = ItemsCategory(id: .random(), name: "Test category")
        categoryRepository.add(category)

        let list = List(id: .random(), name: "Test list", accessType: .private, items: [])
        listRepository.add(list)

        let item = Item(id: .random(), name: "Test item", info: "", state: .toBuy, categoryId: category.id, listId: list.id)
        itemRepository.addItems([item])

        commandBus.execute(RemoveItemsCategoryCommand(category))

        let updatedItem = itemRepository.item(with: item.id)
        XCTAssertTrue(updatedItem?.categoryId == ItemsCategory.default.id)
    }

    func test_can_edit_category_name() {
        let originalName = "Original name"
        let updatedName = "Updated name"
        let category = ItemsCategory(id: .random(), name: originalName)
        categoryRepository.add(category)

        commandBus.execute(UpdateItemsCategoryCommand(category.id, updatedName))

        let categories = categoryRepository.allCategories()
        XCTAssertTrue(categories.contains { $0.name == updatedName })
        XCTAssertFalse(categories.contains { $0.name == originalName })
    }

    func test_cannot_edit_category_name_to_name_that_already_exits() {
        let firstCategory = ItemsCategory(id: .random(), name: "Test category 1")
        let secondCategory = ItemsCategory(id: .random(), name: "Test category 2")
        categoryRepository.add(firstCategory)
        categoryRepository.add(secondCategory)

        commandBus.execute(UpdateItemsCategoryCommand(secondCategory.id, firstCategory.name))

        let categories = categoryRepository.allCategories()
        XCTAssertTrue(categories.contains { $0.name == firstCategory.name })
        XCTAssertTrue(categories.contains { $0.name == secondCategory.name })
    }

    func test_can_edit_default_category_name() {
        let defaultCategoryId = ItemsCategory.default.id
        let newCategoryName = "New category name"

        commandBus.execute(AddDefaultItemsCategoryCommand())
        commandBus.execute(UpdateItemsCategoryCommand(defaultCategoryId, "New category name"))

        let categories = categoryQueries.fetchCategories()
        XCTAssertEqual(categories.first { $0.isDefault }!.name, newCategoryName)
    }
}
