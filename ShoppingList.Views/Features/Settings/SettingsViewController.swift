import ShoppingList_Shared
import ShoppingList_ViewModels

import Combine
import UIKit

public protocol SettingsViewControllerDelegate: AnyObject {
    func close()
    func openSetting(_ settings: SettingsViewModel.Settings)
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
        navigationItem.leftBarButtonItem = closeBarButtonItem
        view.backgroundColor = .background
        
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
            .map(SettingsViewModel.Settings.fromIndex)
            .sink { [weak self] settings in
                if let settings = settings {
                    self?.delegate?.openSetting(settings)
                }
            }
            .store(in: &cancellables)
    }
}
