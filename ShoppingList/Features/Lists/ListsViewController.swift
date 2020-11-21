import UIKit

final class ListsViewController: UIViewController {
    var lists = [List]()
    
    lazy var addListTextFieldWithCancel: TextFieldWithCancel = {
        let textFieldWithCancel =
            TextFieldWithCancel(
                viewController: self,
                placeHolder: "Add new list...")
        textFieldWithCancel.delegate = self
        textFieldWithCancel.layer.zPosition = 1
        textFieldWithCancel.translatesAutoresizingMaskIntoConstraints = false
        return textFieldWithCancel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.register(ListsTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(longPressHandler)))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.backgroundColor = .background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    @objc private func longPressHandler(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let touchLocation = gesture.location(in: tableView)
        guard let touchedRow = tableView.indexPathForRow(at: touchLocation)?.row else { return }
        
        var alertController = ListActionsAlertBuilder(lists[touchedRow])
        alertController.delegate = self
        
        present(alertController.build(), animated: true)
    }
    
    lazy private var goToSettingsBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "Settings"), style: .plain, target: self, action: #selector(goToSettingsScene))
    }()
    
    @objc private func goToSettingsScene() {
        let settingsViewController = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        present(navigationController, animated: true)
    }
    
    lazy private var restoreBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Restore"), style: .plain, target: self, action: #selector(restore))
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    @objc private func restore() {
        let invoker = CommandInvoker.shared
        if invoker.canUndo(.lists) {
            invoker.undo(.lists)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserInterface()
        fetchLists()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CommandInvoker.shared.remove(.lists)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshUserInterface()
    }

    private func setupUserInterface() {
        navigationItem.title = "My lists"
        
        view.addSubview(addListTextFieldWithCancel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            addListTextFieldWithCancel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addListTextFieldWithCancel.topAnchor.constraint(equalTo: view.topAnchor),
            addListTextFieldWithCancel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addListTextFieldWithCancel.heightAnchor.constraint(equalToConstant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: addListTextFieldWithCancel.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func refreshUserInterface() {
        if lists.count > 0 {
            tableView.backgroundView = nil
        } else {
            tableView.setTextIfEmpty("You have not added any lists yet")
        }
        
        restoreBarButtonItem.isEnabled = CommandInvoker.shared.canUndo(.lists)
        navigationItem.rightBarButtonItems = [goToSettingsBarButtonItem, restoreBarButtonItem]
    }
    
    func fetchLists() {
        let myLists = Repository.shared.getLists().sorted { $0.updateDate > $1.updateDate }
        lists = myLists
    }
    
    func getListName(from text: String) -> String {
        return ListNameGenerator().generate(from: text, and: lists)
    }
}
