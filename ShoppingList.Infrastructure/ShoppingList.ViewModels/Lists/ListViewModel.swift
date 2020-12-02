import ShoppingList_Domain
import ShoppingList_Shared

public struct ListViewModel: Hashable {
    public let id: UUID
    public let name: String
    public let accessType: String
    public let isPrivate: Bool
    public let numberOfItemsToBuy: Int

    public let hasItemsToBuy: Bool
    public let hasItemsInBasket: Bool

    public var hasAnyItem: Bool {
        hasItemsToBuy || hasItemsInBasket
    }

    public var formattedUpdateDate: String {
        switch Calendar.current {
        case let calendar where calendar.isDateInToday(updateDate): return "Today"
        case let calendar where calendar.isDateInYesterday(updateDate) : return "Yesterday"
        default: break
        }

        return dateFormatter.string(from: updateDate)
    }

    private let updateDate: Date
    private let dateFormatter: DateFormatter

    public init(_ list: List, _ dateFormatter: DateFormatter) {
        self.id = list.id
        self.name = list.name
        self.accessType = list.accessType.description
        self.isPrivate = list.accessType == .private
        self.numberOfItemsToBuy = list.numberOfItemsToBuy()
        self.updateDate = list.updateDate
        self.dateFormatter = dateFormatter
        self.hasItemsToBuy = list.containsItemsToBuy
        self.hasItemsInBasket = list.containsItemsInBasket
    }
}
