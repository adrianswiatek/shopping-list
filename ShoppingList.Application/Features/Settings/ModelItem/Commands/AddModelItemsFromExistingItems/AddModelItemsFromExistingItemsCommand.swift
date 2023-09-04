import ShoppingList_Domain

public struct AddModelItemsFromExistingItemsCommand: Command {
    public let source: CommandSource

    public init() {
        self.source = .modelItems
    }
}
