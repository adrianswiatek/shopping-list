import ShoppingList_Shared
import ShoppingList_ViewModels

import Combine
import UIKit

public protocol SettingsViewControllerDelegate: class {
    func close()
    func openSetting()
}

public final class SettingsViewController: UIViewController {
    public weak var delegate: SettingsViewControllerDelegate?

    private let tableView: SettingsTableView

    private lazy var closeBarButtonItem: UIBarButtonItem =
        .init(title: "Close", primaryAction: .init { [ weak self] _ in self?.delegate?.close() })

    private let viewModel: SettingsViewModel
    private var cancellables: Set<AnyCancellable>

    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        self.tableView = .init(viewModel)
        self.cancellables = []
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not supported.")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.bind()
    }
    
    private func setupView() {
        title = "Settings"

        navigationController?.navigationBar.backgroundColor = .background
        navigationItem.leftBarButtonItem = closeBarButtonItem
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func bind() {
        tableView.selectedRowAtIndex
            .sink { [weak self] _ in self?.delegate?.openSetting() }
            .store(in: &cancellables)
    }
}
