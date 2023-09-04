import ShoppingList_Domain

public struct ModelItemUpdatedEvent: Event {
    public let modelItemBeforeUpdate: ModelItem
    public let modelItemAfterUpdate: ModelItem

    public init(_ modelItemBeforeUpdate: ModelItem, _ modelItemAfterUpdate: ModelItem) {
        self.modelItemBeforeUpdate = modelItemBeforeUpdate
        self.modelItemAfterUpdate = modelItemAfterUpdate
    }
}
