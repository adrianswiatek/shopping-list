import Combine
import Foundation

final class ConnectivityListener {
    private let connectivityGateway: ConnectivityGateway

    private let listsRepository: ShoppingListsRepository
    private let itemsRepository: ShoppingItemsRepository

    private let eventsBus: EventsBus

    init(
        connectivityGateway: ConnectivityGateway,
        listsRepository: ShoppingListsRepository,
        itemsRepository: ShoppingItemsRepository,
        eventsBus: EventsBus
    ) {
        self.connectivityGateway = connectivityGateway

        self.listsRepository = listsRepository
        self.itemsRepository = itemsRepository

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

    private func addOrUpdateItems(_ items: [ShoppingItem], onList list: ShoppingList) async {
        let statesOfExistingItems = Dictionary(
            uniqueKeysWithValues: await itemsRepository.fetch(list.id).map { ($0.id, $0.state) }
        )

        let withExistingState: (ShoppingItem) -> ShoppingItem = { item in
            if let state = statesOfExistingItems[item.id] {
                return item.updating([.state(to: state)])
            }
            return item
        }

        await itemsRepository.delete(items.map(\.id))
        await itemsRepository.delete(list.id)
        await itemsRepository.add(items.map(withExistingState))
    }
}
