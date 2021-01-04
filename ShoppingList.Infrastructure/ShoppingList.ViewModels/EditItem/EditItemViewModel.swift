import ShoppingList_Application
import ShoppingList_Domain
import Combine

public final class EditItemViewModel: ViewModel {
    public var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    private var currentList: ListViewModel!

    private var stateSubject: CurrentValueSubject<State, Never>

    private let commandBus: CommandBus

    public init(commandBus: CommandBus) {
        self.commandBus = commandBus
        self.stateSubject = .init(.create)
    }

    public func setList(_ list: ListViewModel) {
        currentList = list
    }

    public func setItem(_ item: ItemViewModel) {
        stateSubject.send(.edit(item: item))
    }
}

extension EditItemViewModel {
    public enum State {
        case create
        case edit(item: ItemViewModel)
    }
}
