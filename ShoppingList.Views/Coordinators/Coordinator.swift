import UIKit

public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get }

    func start()
}

internal extension Array where Element == Coordinator {
    mutating func remove(_ coordinator: Coordinator) {
        removeAll { $0 === coordinator }
    }
}
