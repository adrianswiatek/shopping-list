import ShoppingList_Domain

import Foundation

public struct ItemToSearchViewModel: Comparable, Hashable, Identifiable {
    public let id: UUID
    public let name: String
    public let foundName: FoundName?

    private init(id: UUID, name: String, foundName: FoundName?) {
        self.id = id
        self.name = name
        self.foundName = foundName
    }

    public func applyingQuery(_ query: String) -> ItemToSearchViewModel? {
        FoundName.tryMaking(name: name, query: query).map {
            ItemToSearchViewModel(id: id, name: name, foundName: $0)
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

    public func toModelItem() -> ModelItem {
        .init(id: .fromUuid(id), name: name)
    }
}

extension ItemToSearchViewModel {
    public enum Factory {
        public static func fromModelItem(_ item: ModelItem) -> ItemToSearchViewModel {
            .init(id: item.id.toUuid(), name: item.name, foundName: nil)
        }
    }

    public struct FoundName: Comparable, Hashable {
        public let fullName: String
        public let prefix: String
        public let foundPart: String
        public let suffix: String

        public static func tryMaking(name: String, query: String) -> FoundName? {
            let lowercasedName = name.localizedLowercase

            guard let range = lowercasedName.range(of: query.localizedLowercase) else {
                return nil
            }

            let indexFrom: (String.Index) -> String.Index = {
                let distance = lowercasedName.distance(from: lowercasedName.startIndex, to: $0)
                return name.index(name.startIndex, offsetBy: distance)
            }

            let lowerBoundIndex = indexFrom(range.lowerBound)
            let upperBoundIndex = indexFrom(range.upperBound)

            return FoundName(
                fullName: name,
                prefix: String(name.prefix(upTo: lowerBoundIndex)),
                foundPart: String(name[lowerBoundIndex ..< upperBoundIndex]),
                suffix: String(name.suffix(from: upperBoundIndex))
            )
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
