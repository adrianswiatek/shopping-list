import ShoppingList_Domain
import XCTest

final class ListNameGeneratorTests: XCTestCase {
    func test_generate_whenEmptyList_returnsMyList() {
        let sut = ListNameGenerator()
        let result = sut.generate(from: [])
        XCTAssertEqual(result, "My List")
    }

    func test_generate_whenMyListExists_returnsMyList1() {
        let sut = ListNameGenerator()
        let result = sut.generate(from: [
            List(id: .random(), name: "My List", accessType: .private, items: [])
        ])
        XCTAssertEqual(result, "My List 1")
    }

    func test_generate_whenMyListAndMyList1Exists_returnsMyList2() {
        let sut = ListNameGenerator()
        let result = sut.generate(from: [
            List(id: .random(), name: "My List", accessType: .private, items: []),
            List(id: .random(), name: "My List 1", accessType: .private, items: [])
        ])
        XCTAssertEqual(result, "My List 2")
    }

    func test_generate_whenMyListAndMyList2Exists_returnsMyList1() {
        let sut = ListNameGenerator()
        let result = sut.generate(from: [
            List(id: .random(), name: "My List", accessType: .private, items: []),
            List(id: .random(), name: "My List 2", accessType: .private, items: [])
        ])
        XCTAssertEqual(result, "My List 1")
    }

    func test_generate_whenListWithCustomNameExists_returnsMyList() {
        let sut = ListNameGenerator()
        let result = sut.generate(from: [
            List(id: .random(), name: "Custom list name", accessType: .private, items: [])
        ])
        XCTAssertEqual(result, "My List")
    }
}
