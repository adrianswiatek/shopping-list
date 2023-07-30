import Foundation

public enum ItemsSorter {
    public static func sort(_ items: [Item], by orderedItemsIds: [Id<Item>]) -> [Item] {
        var unorderedItems = items
        var result = [Item]()
        
        for itemId in orderedItemsIds {
            if let itemIndex = unorderedItems.firstIndex(where: { $0.id == itemId }) {
                result.append(unorderedItems.remove(at: itemIndex))
            }
        }

        for item in unorderedItems.reversed() {
            result.insert(item, at: 0)
        }

        return result
    }
}
