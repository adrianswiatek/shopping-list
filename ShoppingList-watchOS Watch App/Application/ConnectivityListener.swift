import Combine
import Foundation

final class ConnectivityListener {
    private let connectivityGateway: ConnectivityGateway
    private let listsRepository: ShoppingListsRepository
    private let itemsRepository: ShoppingItemsRepository
    private let settingsService: SettingsService
    private let eventsBus: EventsBus

    init(
        connectivityGateway: ConnectivityGateway,
        listsRepository: ShoppingListsRepository,
        itemsRepository: ShoppingItemsRepository,
        settingsService: SettingsService,
        eventsBus: EventsBus
    ) {
        self.connectivityGateway = connectivityGateway
        self.listsRepository = listsRepository
        self.itemsRepository = itemsRepository
        self.settingsService = settingsService
        self.eventsBus = eventsBus
    }

    func initialize() {
        Task {
            for await listDto in connectivityGateway.onListUpdated.values {
                await handleIncomingList(listDto)
            }
        }
    }

    private func handleIncomingList(_ listDto: UpdateListDto) async {
        let (list, items) = listDto.toEntities()

        await addOrUpdateList(list)
        await addOrUpdateItems(items, onList: list)

        eventsBus.publish(.modelUpdated)
    }

    private func addOrUpdateList(_ list: ShoppingList) async {
        if let existingList = await listsRepository.find(list.id) {
            let updatedList = existingList
                .updating(.name(to: list.name))
                .updating(.visited(to: false))
            await listsRepository.update(updatedList)
        } else {
            await listsRepository.add(list)
        }
    }

    private func addOrUpdateItems(
        _ incomingItems: [ShoppingItem],
        onList list: ShoppingList
    ) async {
        let existingItems = await itemsRepository.fetch(list.id)
        await itemsRepository.delete(incomingItems.map(\.id))
        await itemsRepository.delete(list.id)
        await itemsRepository.add(itemsToAdd(incomingItems, existingItems))
    }

    private func itemsToAdd(
        _ incomingItems: [ShoppingItem],
        _ existingItems: [ShoppingItem]
    ) -> [ShoppingItem] {
        switch settingsService.itemsStateSynchronizationMode() {
        case .appleWatchFirst:
            return incomingItems.map(toItemWithExistingState(existingItems))
        case .iPhoneFirst:
            return incomingItems
        }
    }

    private func toItemWithExistingState(
        _ existingItems: [ShoppingItem]
    ) -> (ShoppingItem) -> ShoppingItem {
        return { incomingItem in
            let itemWithExistingState = existingItems
                .first { $0.id == incomingItem.id }
                .map { incomingItem.updating(.state(to: $0.state)) }
            return itemWithExistingState ?? incomingItem
        }
    }
}
