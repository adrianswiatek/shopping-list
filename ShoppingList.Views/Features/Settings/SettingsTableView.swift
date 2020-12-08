import ShoppingList_Shared
import ShoppingList_ViewModels

import Combine
import UIKit

public final class SettingsTableView: UITableView {
    public var selectedRowAtIndex: AnyPublisher<Int, Never> {
        selectedRowAtIndexSubject.eraseToAnyPublisher()
    }

    private let viewModel: SettingsViewModel
    private let selectedRowAtIndexSubject: PassthroughSubject<Int, Never>

    public init(_ viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        self.selectedRowAtIndexSubject = .init()

        super.init(frame: .zero, style: .plain)

        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not supported.")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        dataSource = self
        allowsMultipleSelection = false
        backgroundColor = .background
        tableFooterView = UIView()
    }
}

extension SettingsTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRowAtIndexSubject.send(indexPath.row)
    }
}

extension SettingsTableView: UITableViewDataSource {
    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.numberOfSettings
    }

    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        settingsCell(for: viewModel.settings(for: indexPath.row))
    }

    private func settingsCell(for settings: SettingsViewModel.Settings) -> UITableViewCell {
        configure(.init(style: .default, reuseIdentifier: nil)) {
            $0.textLabel?.text = settings.rawValue
            $0.textLabel?.textColor = .textPrimary
            $0.backgroundColor = .background
            $0.accessoryType = .disclosureIndicator
        }
    }
}
