
import Foundation

public struct EditItemNameViewModel {
    public let item: ItemToSearchViewModel?
    public var newName: String

    private init(item: ItemToSearchViewModel?, newName: String) {
        self.item = item
        self.newName = newName
    }

    public static var empty: EditItemNameViewModel {
        EditItemNameViewModel(item: nil, newName: "")
    }

    public static func fromItem(_ item: ItemToSearchViewModel) -> EditItemNameViewModel {
        EditItemNameViewModel(item: item, newName: item.name)
    }
}
