import ShoppingList_Domain

public protocol ModelItemQueries {
    func fetchModelItems(_ sortingStrategy: ModelItemService.SortingStrategy) -> [ModelItem]
}
