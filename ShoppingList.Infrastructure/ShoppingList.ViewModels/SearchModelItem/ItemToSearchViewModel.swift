import ShoppingList_Domain

public struct ItemToSearchViewModel: Comparable, Hashable {
    public let name: String
    public let foundName: FoundName?

    public init(item: ModelItem) {
        self.init(name: item.name, foundName: nil)
    }

    public init(name: String) {
        self.init(name: name, foundName: nil)
    }

    private init(name: String, foundName: FoundName?) {
        self.name = name
        self.foundName = foundName
    }

    public func applyingQuery(_ query: String) -> ItemToSearchViewModel? {
        FoundName.tryMaking(name: name, query: query).map {
            ItemToSearchViewModel(name: name, foundName: $0)
        }
    }

    public static func < (lhs: ItemToSearchViewModel, rhs: ItemToSearchViewModel) -> Bool {
        switch (lhs.foundName, rhs.foundName) {
        case (.none, .none):
            return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
        case (.some, .none):
            return false
        case (.none, .some):
            return true
        case (.some(let lhsFoundName), .some(let rhsFoundName)):
            return lhsFoundName < rhsFoundName
        }
    }
}

extension ItemToSearchViewModel {
    public struct FoundName: Comparable, Hashable {
        public let fullName: String
        public let prefix: String
        public let foundPart: String
        public let suffix: String

        public static func tryMaking(name: String, query: String) -> FoundName? {
            if let range = name.localizedLowercase.range(of: query.localizedLowercase) {
                return FoundName(
                    fullName: name,
                    prefix: String(name.prefix(upTo: range.lowerBound)),
                    foundPart: String(name[range.lowerBound ..< range.upperBound]),
                    suffix: String(name.suffix(from: range.upperBound))
                )
            }
            return nil
        }

        private init(fullName: String, prefix: String, foundPart: String, suffix: String) {
            self.fullName = fullName
            self.prefix = prefix
            self.foundPart = foundPart
            self.suffix = suffix
        }

        public static var empty: FoundName {
            FoundName(fullName: "", prefix: "", foundPart: "", suffix: "")
        }

        public static func < (lhs: FoundName, rhs: FoundName) -> Bool {
            let foundOnTheBeginning: (FoundName) -> Bool = { $0.prefix.isEmpty }
            let foundInTheMiddle: (FoundName) -> Bool = { !$0.prefix.isEmpty }

            if foundOnTheBeginning(lhs), foundInTheMiddle(rhs) {
                return true
            } else if foundInTheMiddle(lhs), foundOnTheBeginning(rhs) {
                return false
            } else {
                return lhs.fullName.localizedCaseInsensitiveCompare(rhs.fullName) == .orderedAscending
            }
        }
    }
}
