import Combine

final class ConnectivityGateway {
    var onListUpdated: AnyPublisher<UpdateListDto, Never> {
        connectivity
            .publisher
            .compactMap(UpdateListDto.fromDictionary)
            .map(withAppliedSettings)
            .eraseToAnyPublisher()
    }

    private let connectivity: Connectivity
    private let settingsRepository: SettingsRepository

    init(connectivity: Connectivity, settingsRepository: SettingsRepository) {
        self.connectivity = connectivity
        self.connectivity.initialize()
        self.settingsRepository = settingsRepository
    }

    private func withAppliedSettings(_ list: UpdateListDto) -> UpdateListDto {
        let synchronizeBasket = settingsRepository.get(.synchronizeBasket) == true
        return synchronizeBasket ? list : list.filteringItems { $0.inBasket == false }
    }
}
