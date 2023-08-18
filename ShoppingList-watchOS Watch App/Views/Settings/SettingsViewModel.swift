import Combine
import SwiftUI

extension SettingsView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published
        var listSortingType: ListSortingType

        @Published
        var basketSortingType: BasketSortingType

        @Published
        var showCategoriesOfItemsToBuy: Bool

        @Published
        var synchronizeBasket: Bool

        private let settingsService: SettingsService
        private var cancellables: Set<AnyCancellable>

        init(settingsService: SettingsService) {
            self.settingsService = settingsService

            self.listSortingType = .init(settingsService.listSortingOptions())
            self.basketSortingType = .init(settingsService.basketSortingOptions())
            self.showCategoriesOfItemsToBuy = settingsService.showCategoriesOfItemsToBuy()
            self.synchronizeBasket = settingsService.synchronizeBasket()

            self.cancellables = []

            self.bind()
        }

        private func bind() {
            $listSortingType
                .removeDuplicates()
                .sink { [weak settingsService] in
                    settingsService?.setValue($0.sortingOrder.rawValue, forKey: .listSortingOrder)
                }
                .store(in: &cancellables)

            $basketSortingType
                .removeDuplicates()
                .sink { [weak settingsService] in
                    settingsService?.setValue($0.sortingType.rawValue, forKey: .basketSortingType)
                }
                .store(in: &cancellables)

            $showCategoriesOfItemsToBuy
                .removeDuplicates()
                .sink { [weak settingsService] in
                    settingsService?.setValue($0, forKey: .showCategoriesOfItemsToBuy)
                }
                .store(in: &cancellables)

            $synchronizeBasket
                .removeDuplicates()
                .sink { [weak settingsService] in
                    settingsService?.setValue($0, forKey: .synchronizeBasket)
                }
                .store(in: &cancellables)
        }
    }

    struct ListSortingType: Hashable {
        let sortingOrder: Settings.ItemsSortingOrder

        init(_ options: Settings.ItemsSortingOptions) {
            self.init(options.order)
        }

        private init(_ sortingOrder: Settings.ItemsSortingOrder) {
            self.sortingOrder = sortingOrder
        }

        static let inAscendingOrder = ListSortingType(.ascending)
        static let inDescendingOrder = ListSortingType(.descending)

        var formatted: String {
            switch sortingOrder {
            case .ascending:
                return "in ascending order"
            case .descending:
                return "in descending order"
            }
        }
    }

    struct BasketSortingType: Hashable {
        let sortingType: Settings.ItemsSortingType

        init(_ options: Settings.ItemsSortingOptions) {
            self.init(options.type)
        }

        private init(_ sortingType: Settings.ItemsSortingType) {
            self.sortingType = sortingType
        }

        static let inAlphabeticalOrder = BasketSortingType(.alphabeticalOrder)
        static let inOrderOfAddition = BasketSortingType(.updatingOrder)

        var formatted: String {
            switch sortingType {
            case .alphabeticalOrder:
                return "alphabetically"
            case .updatingOrder:
                return "in order of addition"
            }
        }
    }
}
