import UIKit

class ListsViewController: UIViewController {
    
    var lists = [List]()
    
    lazy var addListTextFieldWithCancel: TextFieldWithCancel = {
        let textFieldWithCancel = TextFieldWithCancel(viewController: self, placeHolder: "Add new list...")
        textFieldWithCancel.delegate = self
        textFieldWithCancel.layer.zPosition = 1
        textFieldWithCancel.translatesAutoresizingMaskIntoConstraints = false
        return textFieldWithCancel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.register(ListsTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var goToSettingsBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "Settings"), style: .plain, target: self, action: #selector(goToSettingsScene))
    }()
    
    @objc private func goToSettingsScene() {
        let settingsViewController = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        present(navigationController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchLists()
        setScene()
    }
    
    private func setupUserInterface() {
        navigationItem.title = "My lists"
        
        navigationItem.rightBarButtonItem = goToSettingsBarButtonItem
        
        view.addSubview(addListTextFieldWithCancel)
        addListTextFieldWithCancel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addListTextFieldWithCancel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        addListTextFieldWithCancel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addListTextFieldWithCancel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: addListTextFieldWithCancel.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setScene() {
        if lists.count > 0 {
            tableView.backgroundView = nil
        } else {
            tableView.setTextIfEmpty("You have not added any lists yet")
        }
    }
    
    func fetchLists() {
        let myLists = Repository.shared.getLists().sorted { $0.updateDate > $1.updateDate }
        lists = myLists
    }
}
