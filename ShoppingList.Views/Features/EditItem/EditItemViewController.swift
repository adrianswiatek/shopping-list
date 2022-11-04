import ShoppingList_Domain
import ShoppingList_Shared
import ShoppingList_ViewModels
import Combine
import UIKit

public final class EditItemViewController: UIViewController {
    internal static let labelsWidth: CGFloat = 100
    internal static let labelsLeftPadding: CGFloat = 16

    private let itemNameView: ItemNameForEditItem = .init()
    private let infoView: InfoForEditItem = .init()
    private let categoriesView: CategoriesForEditItem = .init()
    private let listsView: ListsForEditItem = .init()
    
    private lazy var cancelBarButtonItem: UIBarButtonItem =
        .init(systemItem: .cancel, primaryAction: .init { [weak self] _ in
            self?.dismiss(animated: true)
        })
    
    private lazy var saveBarButtonItem: UIBarButtonItem =
        .init(systemItem: .save, primaryAction: .init { [weak self] _ in self?.save() })
    
    @objc
    private func save() {
        guard let itemName = itemNameView.text else { return }
        guard itemNameView.isValid() else { return }

        viewModel.saveItem(name: itemName, info: infoView.text ?? "")
    }

    private let viewModel: EditItemViewModel
    private var cancellables: Set<AnyCancellable>

    public init(viewModel: EditItemViewModel) {
        self.viewModel = viewModel
        self.cancellables = []

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
        self.viewModel.fetchData()
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationController?.navigationBar.barTintColor = .systemBackground
    }

    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.isOpaque = false
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem
        navigationController?.navigationBar.backgroundColor = .background
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.darkGray,
        ]

        view.addSubview(itemNameView)
        NSLayoutConstraint.activate([
            itemNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemNameView.topAnchor.constraint(equalTo: view.topAnchor),
            itemNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemNameView.heightAnchor.constraint(equalToConstant: 70)
        ])

        view.addSubview(infoView)
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.topAnchor.constraint(equalTo: itemNameView.bottomAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 70)
        ])

        view.addSubview(categoriesView)
        NSLayoutConstraint.activate([
            categoriesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesView.topAnchor.constraint(equalTo: infoView.bottomAnchor),
            categoriesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesView.heightAnchor.constraint(equalToConstant: 100)
        ])

        view.addSubview(listsView)
        NSLayoutConstraint.activate([
            listsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listsView.topAnchor.constraint(equalTo: categoriesView.bottomAnchor),
            listsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listsView.heightAnchor.constraint(equalToConstant: 100)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    private func bind() {
        viewModel.state
            .sink { [weak self] in
                switch $0 {
                case .create:
                    self?.itemNameView.becomeFirstResponder()
                    self?.listsView.isHidden = true
                    self?.navigationItem.title = "Add Item"
                case .edit(let item):
                    self?.itemNameView.text = item.name
                    self?.infoView.text = item.info
                    self?.navigationItem.title = "Edit Item"
                }
            }
            .store(in: &cancellables)

        viewModel.categories
            .combineLatest(viewModel.selectedCategory)
            .sink { [weak self] in
                self?.categoriesView.setCategories($0)
                self?.categoriesView.selectCategory($1)
            }
            .store(in: &cancellables)

        viewModel.lists
            .combineLatest(viewModel.selectedList)
            .sink { [weak self] in
                self?.listsView.setLists($0)
                self?.listsView.selectList($1)
            }
            .store(in: &cancellables)

        viewModel.dismiss
            .sink { [weak self] in self?.dismiss(animated: true) }
            .store(in: &cancellables)

        itemNameView.onAction
            .sink { [weak self] action in
                guard case .showViewController(let viewController) = action else {
                    return
                }
                self?.present(viewController, animated: true)
            }
            .store(in: &cancellables)

        categoriesView.onAction
            .sink { [weak self] in self?.handleAction($0) }
            .store(in: &cancellables)

        listsView.onAction
            .sink { [weak self] in self?.handleAction($0) }
            .store(in: &cancellables)
    }

    private func handleAction(_ action: CategoriesForEditItem.Action) {
        switch action {
        case .addCategory(let name):
            viewModel.addCategory(with: name)
        case .selectCategory(let uuid):
            viewModel.selectCategory(with: uuid)
        case .showViewController(let viewController):
            itemNameView.resignFirstResponder()
            present(viewController, animated: true)
        }
    }

    private func handleAction(_ action: ListsForEditItem.Action) {
        switch action {
        case .addList(let name):
            viewModel.addList(with: name)
        case .selectList(let uuid):
            viewModel.selectList(with: uuid)
        case .showViewController(let viewController):
            itemNameView.resignFirstResponder()
            present(viewController, animated: true)
        }
    }
    
    @objc
    private func handleTapGesture(gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        itemNameView.resignFirstResponder()
        infoView.resignFirstResponder()
    }
}

extension EditItemViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
