import ShoppingList_Domain

public struct ListUpdatedEvent: Event {
    public let list: List

    public init(_ list: List) {
        self.list = list
    }
}
