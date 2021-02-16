import ShoppingList_Domain

public struct ItemsCategoryUpdatedEvent: Event {
    public let categoryBeforeUpdate: ItemsCategory
    public let categoryAfterUpdate: ItemsCategory

    public init(_ categoryBeforeUpdate: ItemsCategory, _ categoryAfterUpdate: ItemsCategory) {
        self.categoryBeforeUpdate = categoryBeforeUpdate
        self.categoryAfterUpdate = categoryAfterUpdate
    }
}
