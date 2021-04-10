import ShoppingList_Application
import ShoppingList_Domain
import ShoppingList_ViewModels
import Combine
import XCTest

final class ManageCategoriesViewModelTests: XCTestCase {
    private var sut: ManageCategoriesViewModel!
    private var categoryRepository: ItemsCategoryRepository!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()

        let container = TestContainerProvider.provide()
        self.sut = container.resolve(ManageCategoriesViewModel.self)
        self.categoryRepository = container.resolve(ItemsCategoryRepository.self)
        self.cancellables = []

        container.resolve(CommandBus.self).execute(AddDefaultItemsCategoryCommand())
    }

    override func tearDown() {
        self.categoryRepository.removeAll()

        self.cancellables = nil
        self.categoryRepository = nil
        self.sut = nil

        super.tearDown()
    }

    func test_addCategory_publishes_categories() {
        let expectation = self.expectation(description: "categoriesPublisher expectation")
        var publishedCategories = [ItemsCategoryViewModel]()

        sut.categoriesPublisher
            .dropFirst()
            .sink {
                publishedCategories = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.addCategory(with: "Added category")

        wait(for: [expectation], timeout: 0.1)

        XCTAssertTrue(publishedCategories.contains { $0.name == "Added category" })
    }

    func test_updateCategory_publishes_categories() {
        let category = ItemsCategory(id: .random(), name: "Test category")
        categoryRepository.add(category)

        let expectation = self.expectation(description: "categoriesPublisher expectation")
        var publishedCategories = [ItemsCategoryViewModel]()

        sut.categoriesPublisher
            .dropFirst()
            .sink {
                publishedCategories = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.updateCategory(with: category.id.toUuid(), name: "Updated test category")

        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(publishedCategories.contains { $0.name == "Updated test category" })
    }

    func test_removeCategory_publishes_categories() {
        let expectation = self.expectation(description: "categoriesPublisher expectation")
        expectation.expectedFulfillmentCount = 2
        var publishedCategories = [ItemsCategoryViewModel]()

        sut.categoriesPublisher
            .dropFirst()
            .sink {
                publishedCategories = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.addCategory(with: "Category to remove")

        sut.removeCategory(with: publishedCategories.first { $0.name == "Category to remove" }!.uuid)

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(publishedCategories.count, 1)
    }

    func test_restoreCategory_publishes_categories() {
        let expectation = self.expectation(description: "categoriesPublisher expectation")
        expectation.expectedFulfillmentCount = 3
        var publishedCategories = [ItemsCategoryViewModel]()

        sut.categoriesPublisher
            .dropFirst()
            .sink {
                publishedCategories = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.addCategory(with: "Category to restore")
        sut.removeCategory(with: publishedCategories.first { $0.name == "Category to restore" }!.uuid)

        sut.restoreCategory()

        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(publishedCategories.contains { $0.name == "Category to restore" })
    }
}
