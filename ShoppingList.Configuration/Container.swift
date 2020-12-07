import ShoppingList_Application
import ShoppingList_Domain
import ShoppingList_ViewModels
import ShoppingList_Views
import ShoppingList_Persistence

import Swinject
import UIKit

public final class Container {
    private let container: Swinject.Container

    public init() {
        container = .init()

        registerQueries()
        registerUseCases()
        registerRepositories()
        registerViewModels()
        registerOtherObjects()
    }

    public func resolveRootViewController() -> UIViewController {
        UINavigationController(rootViewController: ListsViewController(
            viewModel: container.resolve(ListsViewModel.self)!
        ))
    }

    private func registerQueries() {
        container.register(ListQueries.self) {
            ListService(
                listRepository: $0.resolve(ListRepository.self)!,
                itemRepository: $0.resolve(ItemRepository.self)!,
                listNameGenerator: .init()
            )
        }
    }

    private func registerUseCases() {
        container.register(ListUseCases.self) {
            ListService(
                listRepository: $0.resolve(ListRepository.self)!,
                itemRepository: $0.resolve(ItemRepository.self)!,
                listNameGenerator: .init()
            )
        }
    }

    private func registerRepositories() {
        container.register(ListRepository.self) { _ in
            Repository.shared
        }

        container.register(ItemRepository.self) { _ in
            Repository.shared
        }
    }

    private func registerViewModels() {
        container.register(ListsViewModel.self) {
            ListsViewModel(
                listQueries: $0.resolve(ListQueries.self)!,
                listUseCases: $0.resolve(ListUseCases.self)!,
                commandInvoker: $0.resolve(CommandInvoker.self)!
            )
        }
    }

    private func registerOtherObjects() {
        container.register(CommandInvoker.self) { _ in
            InMemoryCommandInvoker(commandHandlers: [
                AddListCommandHandler(Repository.shared),
                RemoveListCommandHandler(Repository.shared)
            ])
        }.inObjectScope(.container)
    }
}
