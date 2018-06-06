import Foundation

struct ItemsSorter {
    static func sort(_ items: [Item], by orderedItemsIds: [UUID]) -> [Item] {
        var unorderedItems = items
        var result = [Item]()
        
        for itemId in orderedItemsIds {
            guard let itemIndex = unorderedItems.index(where: { $0.id == itemId }) else { continue }
            result.append(unorderedItems.remove(at: itemIndex))
        }
        
        unorderedItems.reversed().forEach { result.insert($0, at: 0) }
        return result
    }
}
