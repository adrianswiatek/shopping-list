import ShoppingList_Domain
import XCTest

final class SharedItemsFormatterTests: XCTestCase {
    private var sut: SharedItemsFormatter!

    override func setUp() {
        super.setUp()
        self.sut = .init()
    }

    override func tearDown() {
        super.tearDown()
        self.sut = nil
    }

    public func test_formatWithoutCategories_withEmptyItems_returnsEmptyString() {
        XCTAssertEqual(sut.formatWithoutCategories([]), "")
    }

    public func test_formatWithoutCategories_withOneItem_returnsFormattedString() {
        let item = ItemToShare(name: "Name", info: "Info", categoryName: "Category")
        let expected = "Name (Info)"

        let result = sut.formatWithoutCategories([item])

        XCTAssertEqual(result, expected)
    }

    public func test_formatWithoutCategories_withTwoItems_returnsFormattedString() {
        let item1 = ItemToShare(name: "Name 1", info: "Info 1", categoryName: "Category")
        let item2 = ItemToShare(name: "Name 2", info: "Info 2", categoryName: "Category")
        let expected = "Name 1 (Info 1)\nName 2 (Info 2)"

        let result = sut.formatWithoutCategories([item1, item2])

        XCTAssertEqual(result, expected)
    }

    public func test_formatWithCategories_withEmptyItems_returnsEmptyString() {
        XCTAssertEqual(sut.formatWithCategories([]), "")
    }

    public func test_formatWithCategories_withOneItem_returnsFormattedString() {
        let item = ItemToShare(name: "Name", info: "Info", categoryName: "Category")
        let expected = "CATEGORY:\nName (Info)"

        let result = sut.formatWithCategories([item])

        XCTAssertEqual(result, expected)
    }

    public func test_formatWithCategories_withTwoItemInTheSameCategory_returnsFormattedString() {
        let item1 = ItemToShare(name: "Name 1", info: "Info 1", categoryName: "Category")
        let item2 = ItemToShare(name: "Name 2", info: "Info 2", categoryName: "Category")
        let expected = "CATEGORY:\nName 1 (Info 1)\nName 2 (Info 2)"

        let result = sut.formatWithCategories([item1, item2])

        XCTAssertEqual(result, expected)
    }

    public func test_formatWithCategories_withTwoItemsInDifferentCategories_returnsFormattedString() {
        let item1 = ItemToShare(name: "Name 1", info: "Info 1", categoryName: "Category 1")
        let item2 = ItemToShare(name: "Name 2", info: "Info 2", categoryName: "Category 2")
        let expected = "CATEGORY 1:\nName 1 (Info 1)\nCATEGORY 2:\nName 2 (Info 2)"

        let result = sut.formatWithCategories([item1, item2])

        XCTAssertEqual(result, expected)
    }
}
