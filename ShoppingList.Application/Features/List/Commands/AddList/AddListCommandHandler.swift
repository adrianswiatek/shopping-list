import ShoppingList_Domain

public final class AddListCommandHandler: CommandHandler {
    private let listRepository: ListRepository
    private let listNameGenerator: ListNameGenerator
    private let eventBus: EventBus

    public init(_ listRepository: ListRepository, _ listNameGenerator: ListNameGenerator, _ eventBus: EventBus) {
        self.listRepository = listRepository
        self.listNameGenerator = listNameGenerator
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        guard let command = command as? AddListCommand else {
            return false
        }

        let listWithGivenName = listRepository.allLists().first {
            $0.name == command.name
        }
        return listWithGivenName == nil
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? AddListCommand else {
            preconditionFailure("Cannot execute given command.")
        }

        let lists: [List] = listRepository.allLists()
        let list: List = .withName(provideListName(basedOn: command.name, and: lists))

        listRepository.add(list)
        eventBus.send(ListAddedEvent(list))
    }

    private func provideListName(basedOn name: String, and lists: [List]) -> String {
        name.isEmpty ? listNameGenerator.generate(from: lists) : name
    }
}
