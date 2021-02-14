import ShoppingList_Domain

public struct ListAddedEvent: Event {
    public let list: List

    public init(_ list: List) {
        self.list = list
    }
}
