import ShoppingList_Application
import ShoppingList_Domain

public final class ConnectivityGateway: ConnectivityService {
    private let watchConnectivity: WatchConnectivity

    public init(_ watchConnectivity: WatchConnectivity) {
        self.watchConnectivity = watchConnectivity
    }

    public func sendRequest(_ request: ConnectivitySendRequest) {
        let itemsDto: [ItemDto] = .make(request.items)(request.categories)
        let listDto: ListDto = .make(request.list)
        let updateListDto: UpdateListDto = .make(listDto)(itemsDto)

        watchConnectivity.sendDictionary(updateListDto.toDictionary())
    }
}
