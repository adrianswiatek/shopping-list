public final class ListNameGenerator {
    public init() {}

    public func generate(from lists: [List]) -> String {
        let defaultName = "My List"
        
        let listsWithDefaultName = lists.filter { $0.name.hasPrefix(defaultName) }
        if listsWithDefaultName.count == 0 { return defaultName }
        
        let newListNameNumber = generateDefaultNameNumber(from: listsWithDefaultName)
        return newListNameNumber == 0 ? defaultName : "\(defaultName) \(newListNameNumber)"
    }
    
    private func generateDefaultNameNumber(from lists: [List]) -> Int {
        let defaultListNameNumbers = lists
            .map { $0.name.components(separatedBy: " ").last ?? "0" }
            .map { Int($0) ?? 0 }
            .sorted()
        
        for number in 0 ... defaultListNameNumbers.count {
            guard defaultListNameNumbers.contains(number) else {
                return number
            }
        }
        
        let lastDefaultNameNumber = defaultListNameNumbers.last ?? 0
        return lastDefaultNameNumber + 1
    }
}
