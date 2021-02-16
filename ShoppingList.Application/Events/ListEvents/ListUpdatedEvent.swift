import ShoppingList_Domain

public struct ListUpdatedEvent: Event {
    public let listBeforeUpdate: List
    public let listAfterUpdate: List

    public init(_ listBeforeUpdate: List, _ listAfterUpdate: List) {
        self.listBeforeUpdate = listBeforeUpdate
        self.listAfterUpdate = listAfterUpdate
    }
}
