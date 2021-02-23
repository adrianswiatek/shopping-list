public struct SharedItemsFormatter {
    private let separator: String

    public init() {
        separator = "\n"
    }

    public func formatWithCategories(_ items: [ItemToShare]) -> String {
        items
            .reduce(into: [String: [ItemToShare]]()) {
                $0[$1.categoryName] = ($0[$1.categoryName] ?? []) + [$1]
            }
            .map {
                let category = "\($0.uppercased()):"
                let items = $1.map { composeEntry(for: $0) }
                return ([category] + items).joined(separator: separator)
            }
            .joined(separator: separator)
    }

    public func formatWithoutCategories(_ items: [ItemToShare]) -> String {
        items.map { composeEntry(for: $0) }.joined(separator: separator)
    }

    private func composeEntry(for item: ItemToShare) -> String {
        item.info.isEmpty ? item.name : "\(item.name) (\(item.info))"
    }
}
