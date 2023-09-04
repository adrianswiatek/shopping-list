import ShoppingList_Domain

public struct ModelItemsAddedEvent: Event {
    public let modelItems: [ModelItem]

    public init(_ modelItems: [ModelItem]) {
        self.modelItems = modelItems
    }
}
