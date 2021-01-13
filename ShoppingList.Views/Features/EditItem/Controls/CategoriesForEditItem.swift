import ShoppingList_Shared
import ShoppingList_ViewModels
import Combine
import UIKit

public final class CategoriesForEditItem: UIView {
    public var onAction: AnyPublisher<Action, Never> {
        onActionSubject.eraseToAnyPublisher()
    }
    
    private let label: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        $0.text = "CATEGORY:"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private lazy var pickerView: UIPickerView = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.dataSource = self
        $0.delegate = self
    }

    private lazy var addButton: UIButton = configure(.init(type: .system)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(#imageLiteral(resourceName: "Add"), for: .normal)
        $0.addAction(.init { [weak self] _ in
            guard let self = self else { return }
            self.onActionSubject.send(.showViewController(self.addCategoryPopup()))
        }, for: .touchUpInside)
    }

    private var categories: [ItemsCategoryViewModel]
    private let onActionSubject: PassthroughSubject<Action, Never>

    public init() {
        self.categories = []
        self.onActionSubject = .init()

        super.init(frame: .zero)

        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }

    public func setCategories(_ categories: [ItemsCategoryViewModel]) {
        self.categories = categories
        self.pickerView.reloadComponent(0)
    }

    public func selectCategory(_ category: ItemsCategoryViewModel) {
        guard let index = categories.firstIndex(where: { $0.name == category.name }) else {
            return
        }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: EditItemViewController.labelsLeftPadding
            ),
            label.widthAnchor.constraint(equalToConstant: EditItemViewController.labelsWidth),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            addButton.heightAnchor.constraint(equalToConstant: 48),
            addButton.widthAnchor.constraint(equalToConstant: 48),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(pickerView)
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: label.trailingAnchor),
            pickerView.topAnchor.constraint(equalTo: topAnchor),
            pickerView.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func addCategoryPopup() -> PopupWithTextFieldController {
        let controller = PopupWithTextFieldController()
        controller.modalPresentationStyle = .overFullScreen
        controller.popupTitle = "Add Category"
        controller.placeholder = "Enter category name..."
        controller.saved = { [weak self] in
            self?.onActionSubject.send(.addCategory(name: $0))
        }

        let notEmptyRule = ValidationButtonRuleLeaf.notEmptyCategoryRule
        let uniqueRule = ValidationButtonRuleLeaf(
            message: "Category with given name already exists.",
            predicate: { [weak self] text in
                self?.categories.allSatisfy { $0.name != text } == true
            }
        )
        controller.set(ValidationButtonRuleComposite(rules: notEmptyRule, uniqueRule))
        return controller
    }
}

extension CategoriesForEditItem: UIPickerViewDelegate {
    public func pickerView(
        _ pickerView: UIPickerView,
        rowHeightForComponent component: Int
    ) -> CGFloat {
        24
    }

    public func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
    ) -> UIView {
        let label = UILabel()
        label.text = categories[row].name
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }
}

extension CategoriesForEditItem: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    public func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        categories.count
    }

    public func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        onActionSubject.send(
            .selectCategory(uuid: categories[row].uuid)
        )
    }
}

extension CategoriesForEditItem {
    public enum Action {
        case addCategory(name: String)
        case selectCategory(uuid: UUID)
        case showViewController(_ viewController: UIViewController)
    }
}
