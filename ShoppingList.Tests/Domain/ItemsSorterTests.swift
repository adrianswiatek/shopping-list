import ShoppingList_Domain
import XCTest

final class ItemsSorterTests: XCTestCase {
    func test_sort_returnsSortedItems() {
        let items: [Item] = (0 ..< 3).map {
            .toBuy(name: "Test item \($0)", info: nil, listId: .random())
        }
        let orderedItemsId: [Id<Item>] = items.map { $0.id }.reversed()

        let sortedItems = ItemsSorter.sort(items, by: orderedItemsId)

        XCTAssertNotEqual(orderedItemsId, items.map { $0.id })
        XCTAssertEqual(orderedItemsId, sortedItems.map { $0.id })
    }
}
