struct SharedItemsFormatter {
    private let separator = "\n"

    func format(_ items: [[Item]], withCategories categories: [Category]) -> String {
        var result = [String]()

        for (categoryIndex, category) in categories.enumerated() {
            result.append("\(category.name.uppercased()):")

            for item in items[categoryIndex] {
                result.append(item.name)
            }
        }

        return result.joined(separator: separator)
    }

    func format(_ items: [[Item]]) -> String {
        return items.flatMap { $0 }.map { $0.name }.joined(separator: separator)
    }
}
