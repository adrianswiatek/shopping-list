import ShoppingList_Domain

public struct ModelItemFoundEvent: Event {
    public let modelItem: ModelItem

    public init(_ modelItem: ModelItem) {
        self.modelItem = modelItem
    }
}
