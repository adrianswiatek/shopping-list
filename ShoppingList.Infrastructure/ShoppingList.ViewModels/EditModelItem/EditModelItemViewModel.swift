import ShoppingList_Application
import ShoppingList_Domain
import Combine

public final class EditModelItemViewModel: ViewModel {
    public var dismissPublisher: AnyPublisher<Void, Never> {
        eventBus.events
            .filterType(ModelItemUpdatedEvent.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    public var modelItemPublisher: AnyPublisher<ModelItemViewModel, Never> {
        modelItemSubject.eraseToAnyPublisher()
    }

    private let modelItemSubject: CurrentValueSubject<ModelItemViewModel, Never>

    private var cancellables: Set<AnyCancellable>

    private let commandBus: CommandBus
    private let eventBus: EventBus

    public init(commandBus: CommandBus, eventBus: EventBus) {
        self.commandBus = commandBus
        self.eventBus = eventBus

        self.modelItemSubject = .init(.empty)

        self.cancellables = []
    }

    public func setModelItem(_ modelItem: ModelItemViewModel) {
        self.modelItemSubject.send(modelItem)
    }

    public func saveModelItem(name: String) {
        let modelItemId: Id<ModelItem> = .fromUuid(modelItemSubject.value.uuid)
        commandBus.execute(UpdateModelItemCommand(modelItemId, name))
    }
}
