import ShoppingList_Domain
import ShoppingList_Shared
import UIKit

public final class ManageCategoriesViewController: UIViewController {
    private var categories = [ItemsCategory]()
    private var items = [Item]()

    private lazy var addCategoryTextField: TextFieldWithCancel =
        configure(.init(viewController: self, placeHolder: "Add new category...")) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.set(getValidationButtonRule())
            $0.delegate = self
            $0.layer.zPosition = 1
        }
    
    private lazy var restoreBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Restore"), style: .plain, target: self, action: #selector(restore))
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    private lazy var tableView: UITableView = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .background
        $0.allowsSelection = false
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 60
        $0.tableFooterView = UIView()
        $0.register(ManageCategoriesTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        title = "Manage Categories"
        view.backgroundColor = .background
        
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(addCategoryTextField)
        NSLayoutConstraint.activate([
            addCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addCategoryTextField.topAnchor.constraint(equalTo: view.topAnchor),
            addCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addCategoryTextField.heightAnchor.constraint(equalToConstant: 50)
        ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: addCategoryTextField.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchCategories()
        self.fetchItems()
        self.tableView.reloadData()
        self.refreshUserInterface()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Todo: command
        // CommandInvoker.shared.remove(.categories)
    }
    
    public func refreshUserInterface() {
        // Todo: command
        // restoreBarButtonItem.isEnabled = CommandInvoker.shared.canUndo(.categories)
        navigationItem.rightBarButtonItem = restoreBarButtonItem
    }
    
    public func fetchCategories() {
        // Todo: repository
        // var fetchedCategories = Repository.shared.getCategories()
        var fetchedCategories = [ItemsCategory]()
        let defaultCategory = ItemsCategory.default
        if fetchedCategories.first(where: { $0.id == defaultCategory.id }) == nil {
            fetchedCategories.append(defaultCategory)
        }
        
        categories = fetchedCategories.sorted { $0.name < $1.name }
    }
    
    public func fetchItems() {
        // Todo: repository
        // items = Repository.shared.getItems()
    }

    private func getValidationButtonRule() -> ValidationButtonRule {
        let notEmptyRule = ValidationButtonRuleLeaf.getNotEmptyCategoryRule()
        let uniqueRule = ValidationButtonRuleLeaf(
            message: "Category with given name already exists.",
            predicate: { [unowned self] text in self.categories.first { $0.name == text } == nil }
        )
        return ValidationButtonRuleComposite(rules: notEmptyRule, uniqueRule)
    }

    @objc
    private func restore() {
        // Todo: command
        // let invoker = CommandInvoker.shared
        // if invoker.canUndo(.categories) {
        //     invoker.undo(.categories)
        // }
    }
}

extension ManageCategoriesViewController: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let builder = EditContextualActionBuilder(
            viewController: self,
            category: categories[indexPath.row],
            categories: categories,
            saved: { self.categoryEdited(to: $0, at: indexPath) },
            savedDefault: { self.defaultCategoryNameChanged(to: $0, at: indexPath) }
        )

        return UISwipeActionsConfiguration(actions: [builder.build()])
    }

    private func defaultCategoryNameChanged(to name: String, at indexPath: IndexPath) {
        let updatedCategory = updateCategory(to: name, at: indexPath)
        updateTableViewAfterCategoryUpdate(currentIndexPath: indexPath, category: updatedCategory)
        // Todo: repository
        // Repository.shared.defaultCategoryName = updatedCategory.name
    }

    private func categoryEdited(to name: String, at indexPath: IndexPath) {
        let updatedCategory = updateCategory(to: name, at: indexPath)
        updateTableViewAfterCategoryUpdate(currentIndexPath: indexPath, category: updatedCategory)
        // Todo: repository
        // Repository.shared.update(updatedCategory)
    }

    private func updateCategory(to name: String, at indexPath: IndexPath) -> ItemsCategory {
        let existingCategory = categories[indexPath.row]
        let newCategory = existingCategory.withName(name)
        categories[indexPath.row] = newCategory
        categories.sort { $0.name < $1.name }
        return newCategory
    }

    private func updateTableViewAfterCategoryUpdate(currentIndexPath: IndexPath, category: ItemsCategory) {
        guard let newCategoryIndex = categories.firstIndex(where: { $0.id == category.id }) else { return }

        let newIndexPath = IndexPath(row: newCategoryIndex, section: 0)
        if newIndexPath != currentIndexPath {
            tableView.moveRow(at: currentIndexPath, to: newIndexPath)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) { [unowned self] in
            self.tableView.reloadRows(at: [newIndexPath], with: .automatic)
        }
    }

    public func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let category = categories[indexPath.row]

        let builder = DeleteContextualActionBuilder(
            viewController: self,
            category: category,
            isCategoryEmpty: items.filter { $0.category.id == category.id }.count == 0,
            deleteCategory: { self.deleteCategory(at: indexPath) },
            deletedCategoryWithItems: deletedCategoryWithItems)
        return UISwipeActionsConfiguration(actions: [builder.build()])
    }

    private func deleteCategory(at indexPath: IndexPath) {
//        let category = categories.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        // Todo: repository
        // Repository.shared.remove(category)
    }

    private func deletedCategoryWithItems() {
        guard let indexOfDefaultCategory = categories.firstIndex(where: { $0.id == ItemsCategory.default.id }) else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.fetchItems()

            let indexPathOfDefaultCategory = IndexPath(row: indexOfDefaultCategory, section: 0)
            self.tableView.reloadRows(at: [indexPathOfDefaultCategory], with: .automatic)
        }
    }
}

extension ManageCategoriesViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ManageCategoriesTableViewCell
        let category = categories[indexPath.row]
        cell.category = category
        cell.itemsInCategory = items.map { $0.category }.filter { $0.id == category.id }.count
        return cell
    }
}

extension ManageCategoriesViewController: TextFieldWithCancelDelegate {
    public func textFieldWithCancel(_ textFieldWithCancel: TextFieldWithCancel, didReturnWith text: String) {
        let category = ItemsCategory.withName(text)

        categories.append(category)
        categories.sort { $0.name < $1.name }

        // Todo: repository
        // Repository.shared.add(category)

        guard let index = categories.firstIndex(where: { $0.id == category.id }) else { return }
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}
