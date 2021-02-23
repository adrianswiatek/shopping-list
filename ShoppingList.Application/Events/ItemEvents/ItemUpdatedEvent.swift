import ShoppingList_Domain

public struct ItemUpdatedEvent: Event {
    public let itemBeforeUpdate: Item
    public let itemAfterUpdate: Item

    public init(_ itemBeforeUpdate: Item, _ itemAfterUpdate: Item) {
        self.itemBeforeUpdate = itemBeforeUpdate
        self.itemAfterUpdate = itemAfterUpdate
    }
}
