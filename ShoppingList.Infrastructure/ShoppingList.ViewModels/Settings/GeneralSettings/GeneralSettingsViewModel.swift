import ShoppingList_Application

import Combine

public final class GeneralSettingsViewModel: ViewModel, ObservableObject {
    @Published
    public var skipSearchSummaryView: Bool

    private var cancellables: Set<AnyCancellable>
    private let localPreferences: LocalPreferences

    public init(localPreferences: LocalPreferences) {
        self.localPreferences = localPreferences
        self.skipSearchSummaryView = localPreferences.shouldSkipSearchSummaryView
        self.cancellables = []

        self.bind()
    }

    private func bind() {
        $skipSearchSummaryView
            .removeDuplicates()
            .sink { [weak self] in
                self?.localPreferences.shouldSkipSearchSummaryView = $0
            }
            .store(in: &cancellables)
    }
}
