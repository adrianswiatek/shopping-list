import ShoppingList_ViewModels
import Combine
import UIKit

public final class EditModelItemViewController: UIViewController {
    private let itemNameView: ItemNameForEditItem = .init()
    private let categoriesView: CategoriesForEditItem = .init()

    private lazy var cancelBarButtonItem: UIBarButtonItem =
        .init(systemItem: .cancel, primaryAction: .init { [weak self] _ in
            self?.dismiss(animated: true)
        })

    private lazy var saveBarButtonItem: UIBarButtonItem =
        .init(systemItem: .save, primaryAction: .init { [weak self] _ in
            self.map { $0.itemNameView }
                .guard { itemNameView in itemNameView.text != nil && itemNameView.isValid() }
                .do { self?.viewModel.saveModelItem(name: $0.text ?? "") }
        })

    private let viewModel: EditModelItemViewModel
    private var cancellables: Set<AnyCancellable>

    public init(viewModel: EditModelItemViewModel) {
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
        self.viewModel.fetchCategories()
    }

    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.isOpaque = false

        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem
        navigationController?.navigationBar.backgroundColor = .background
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.darkGray
        ]

        view.addSubview(itemNameView)
        NSLayoutConstraint.activate([
            itemNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemNameView.topAnchor.constraint(equalTo: view.topAnchor),
            itemNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemNameView.heightAnchor.constraint(equalToConstant: 70)
        ])

        view.addSubview(categoriesView)
        NSLayoutConstraint.activate([
            categoriesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesView.topAnchor.constraint(equalTo: itemNameView.bottomAnchor),
            categoriesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesView.heightAnchor.constraint(equalToConstant: 100)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    private func bind() {
        viewModel.modelItem
            .sink { [weak self] in self?.itemNameView.text = $0.name }
            .store(in: &cancellables)

        viewModel.categories
            .combineLatest(viewModel.selectedCategory)
            .sink { [weak self] in
                self?.categoriesView.setCategories($0)
                self?.categoriesView.selectCategory($1)
            }
            .store(in: &cancellables)

        viewModel.dismiss
            .sink { [weak self] in self?.dismiss(animated: true) }
            .store(in: &cancellables)

        categoriesView.onAction
            .sink { [weak self] in self?.handleAction($0) }
            .store(in: &cancellables)
    }

    private func handleAction(_ action: CategoriesForEditItem.Action) {
        switch action {
        case .addCategory(let name):
            viewModel.addCategoryWithName(name)
        case .selectCategory(let uuid):
            viewModel.selectCategoryWithUuid(uuid)
        case .showViewController(let viewController):
            itemNameView.resignFirstResponder()
            present(viewController, animated: true)
        }
    }

    @objc
    private func handleTapGesture(gesture: UITapGestureRecognizer) {
        Optional(gesture.state).guard { $0 == .ended }.do { _ in
            itemNameView.resignFirstResponder()
        }
    }
}

extension EditModelItemViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
