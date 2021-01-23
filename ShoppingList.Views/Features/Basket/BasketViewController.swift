import ShoppingList_ViewModels
import ShoppingList_Shared
import Combine
import UIKit

public final class BasketViewController: UIViewController {
    private let tableView: BasketTableView
    private let dataSource: BasketDataSource
    private let toolbar: BasketToolbar

    private let bottomView: UIView =
        configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .background
        }

    private lazy var restoreBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "Restore"), primaryAction: .init { [weak self] _ in
            self?.viewModel.restoreItem()
        })
        button.isEnabled = false
        return button
    }()

    private let viewModel: BasketViewModel
    private var cancellables: Set<AnyCancellable>

    public init(viewModel: BasketViewModel) {
        self.viewModel = viewModel
        self.cancellables = []

        self.tableView = .init()
        self.dataSource = .init(tableView)
        self.toolbar = .init()

        super.init(nibName: nil, bundle: nil)

        self.bind()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not supported.")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.viewModel.fetchItems()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshUserInterface()
        self.tableView.reloadData()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.cleanUp()
    }

    private func setupView() {
        title = "Basket"

        view.addSubview(toolbar)
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 50)
        ])

        view.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func bind() {
        viewModel.itemsPublisher
            .sink { [weak self] in
                self?.dataSource.apply($0)
                self?.refreshUserInterface()
            }
            .store(in: &cancellables)

        viewModel.statePublisher
            .sink { [weak self] in
                switch $0 {
                case .editing:
                    self?.tableView.setEditing(true, animated: true)
                    self?.toolbar.setEditMode()
                case .regular:
                    self?.tableView.setEditing(false, animated: true)
                    self?.toolbar.setRegularMode()
                }
            }
            .store(in: &cancellables)

        tableView.onAction
            .sink { [weak self] in self?.handleTableViewAction($0) }
            .store(in: &cancellables)

        dataSource.onAction
            .sink { [weak self] in self?.handleDataSourceAction($0) }
            .store(in: &cancellables)

        toolbar.onAction
            .sink { [weak self] in self?.handleToolbarAction($0) }
            .store(in: &cancellables)
    }

    private func handleTableViewAction(_ action: BasketTableView.Action) {
        switch action {
        case .moveItemToList(let uuid):
            viewModel.moveToListItems(with: [uuid])
        case .removeItem(let uuid):
            viewModel.removeItems(with: [uuid])
        case .rowTapped:
            toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
        }
    }

    private func handleDataSourceAction(_ action: BasketDataSource.Action) {
        switch action {
        case .moveItemToList(let uuid):
            viewModel.moveToListItems(with: [uuid])
        }
    }

    private func handleToolbarAction(_ action: BasketToolbar.Action) {
        switch action {
        case .action:
            showActionPopup()
        case .cancel:
            viewModel.setState(.regular)
        case .edit:
            viewModel.setState(.editing)
        case .moveToList:
            let selectedItems = tableView.selectedItems()
            viewModel.moveToListItems(with: selectedItems.map { $0.uuid })
        case .remove:
            let selectedItems = tableView.selectedItems()
            viewModel.removeItems(with: selectedItems.map { $0.uuid })
        }
    }

    private func showActionPopup() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alertController.addAction(
            .init(title: "Move all to the list", style: .default) { [weak self] _ in
                self?.viewModel.moveAllItemsToList()
            }
        )

        alertController.addAction(
            .init(title: "Remove all", style: .destructive) { [weak self] _ in
                self?.viewModel.removeAllItems()
            }
        )

        alertController.addAction(
            .init(title: "Cancel", style: .cancel)
        )

        present(alertController, animated: true)
    }

    private func refreshUserInterface() {
        toolbar.setRegularMode()

        if viewModel.isEmpty {
            tableView.setTextIfEmpty("Your basket is empty")
        } else {
            tableView.backgroundView = nil
        }

        restoreBarButtonItem.isEnabled = viewModel.isRestoreButtonEnabled
        navigationItem.rightBarButtonItem = restoreBarButtonItem
    }
}
