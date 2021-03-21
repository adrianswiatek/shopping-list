@testable import ShoppingList
import XCTest

struct TestContainerProvider {
    public static func provide() -> TestContainer {
        (UIApplication.shared.delegate as! AppDelegate).container.resolveTestContainer()
    }
}
