public struct ListNameGenerator {
    public static func generate(from text: String, and lists: [List]) -> String {
        if text != "" { return text }
        
        let defaultName = "My List"
        
        let listsWithDefaultName = lists.filter { $0.name.hasPrefix(defaultName) }
        if listsWithDefaultName.count == 0 { return defaultName }
        
        let newListNameNumber = generateDefaultNameNumber(from: listsWithDefaultName)
        return newListNameNumber == 0 ? defaultName : "\(defaultName) \(newListNameNumber)"
    }
    
    private static func generateDefaultNameNumber(from lists: [List]) -> Int {
        let defaultListNameNumbers = lists
            .map { $0.name.components(separatedBy: " ").last ?? "0" }
            .map { Int($0) ?? 0 }
            .sorted()
        
        for number in (0...defaultListNameNumbers.count) {
            guard defaultListNameNumbers.contains(number) else {
                return number
            }
        }
        
        let lastDefaultNameNumber = defaultListNameNumbers.last ?? 0
        return lastDefaultNameNumber + 1
    }
}
