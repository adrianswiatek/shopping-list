protocol DictionaryDecodable {
    static func fromDictionary(_ dictionary: [String: Any]) -> Self?
}
