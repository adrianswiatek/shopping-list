import ShoppingList_Domain

public final class AddListCommandHandler: CommandHandler {
    private let listRepository: ListRepository
    private let listNameGenerator: ListNameGenerator
    private let eventBus: EventBus

    public init(
        _ listRepository: ListRepository,
        _ listNameGenerator: ListNameGenerator,
        _ eventBus: EventBus
    ) {
        self.listRepository = listRepository
        self.listNameGenerator = listNameGenerator
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is AddListCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? AddListCommand else {
            preconditionFailure("Cannot execute given command.")
        }

        let lists: [List] = listRepository.allLists()

        if listExists(with: command.name, in: lists) {
            eventBus.send(ListNotAddedEvent(.alreadyExists))
        } else {
            let list = provideList(basedOn: command.name, and: lists)
            listRepository.add(list)
            eventBus.send(ListAddedEvent(list))
        }
    }

    private func listExists(with name: String, in lists: [List]) -> Bool {
        lists.first { $0.name == name } != nil
    }

    private func provideList(basedOn name: String, and lists: [List]) -> List {
        let name = name.isEmpty ? listNameGenerator.generate(from: lists) : name
        return .withName(name)
    }
}
