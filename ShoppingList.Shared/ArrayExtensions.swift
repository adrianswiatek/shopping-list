extension Array {
    public func tail() -> [Element] {
        isEmpty ? [] : Array(self[1...])
    }
}
