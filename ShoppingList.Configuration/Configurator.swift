import ShoppingList_Application
import ShoppingList_Domain
import ShoppingList_ViewModels
import ShoppingList_Views
import ShoppingList_Persistence

import UIKit

public final class Configurator {
    public init() {}

    public func rootViewController() -> UIViewController {
        let commandInvoker: CommandInvoker = InMemoryCommandInvoker(commandHandlers: [
            AddListCommandHandler(Repository.shared),
            RemoveListCommandHandler(Repository.shared)
        ])

        let listService = ListService(
            listRepository: Repository.shared,
            itemRepository: Repository.shared,
            listNameGenerator: .init()
        )

        return UINavigationController(rootViewController: ListsViewController(
            viewModel: ListsViewModel(
                listQueries: listService,
                listUseCases: listService,
                commandInvoker: commandInvoker
            )
        ))
    }
}
