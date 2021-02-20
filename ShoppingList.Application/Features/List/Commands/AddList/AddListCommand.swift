import ShoppingList_Domain

public struct AddListCommand: Command {
    public let source: CommandSource

    internal let name: String

    public init(_ name: String) {
        self.name = name
        self.source = .lists
    }
}
 
