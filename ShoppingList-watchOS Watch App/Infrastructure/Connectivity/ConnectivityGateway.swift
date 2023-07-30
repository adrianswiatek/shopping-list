import Combine

final class ConnectivityGateway {
    var onListUpdated: AnyPublisher<UpdateListDto, Never> {
        connectivity
            .publisher
            .compactMap(UpdateListDto.fromDictionary)
            .eraseToAnyPublisher()
    }

    private let connectivity: Connectivity

    init(connectivity: Connectivity) {
        self.connectivity = connectivity
        self.connectivity.initialize()
    }
}
