import ShoppingList_Domain

public final class AddListCommandHandler: CommandHandler {
    private let listRepository: ListRepository
    private let listNameGenerator: ListNameGenerator

    public init(_ listRepository: ListRepository, _ listNameGenerator: ListNameGenerator) {
        self.listRepository = listRepository
        self.listNameGenerator = listNameGenerator
    }

    public func canExecute(_ command: CommandNew) -> Bool {
        guard let command = command as? AddListCommand else {
            return false
        }

        let listWithGivenName = listRepository.allLists().first {
            $0.name == command.name
        }
        return listWithGivenName == nil
    }

    public func execute(_ command: CommandNew) {
        guard canExecute(command), let command = command as? AddListCommand else {
            return
        }

        let lists = listRepository.allLists()
        let listName = provideListName(basedOn: command.name, and: lists)
        listRepository.add(.withName(listName))
    }

    private func provideListName(basedOn name: String, and lists: [List]) -> String {
        name.isEmpty ? listNameGenerator.generate(from: lists) : name
    }
}
