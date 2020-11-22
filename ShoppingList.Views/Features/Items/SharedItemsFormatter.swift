import ShoppingList_Domain

public struct SharedItemsFormatter {
    private let separator = "\n"

    public func format(_ items: [[Item]], withCategories categories: [ItemsCategory]) -> String {
        var result = [String]()

        for (categoryIndex, category) in categories.enumerated() {
            result.append("\(category.name.uppercased()):")

            for item in items[categoryIndex] {
                result.append(item.name)
            }
        }

        return result.joined(separator: separator)
    }

    public func format(_ items: [[Item]]) -> String {
        items.flatMap { $0 }.map { $0.name }.joined(separator: separator)
    }
}
