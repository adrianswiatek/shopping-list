public protocol ValidationButtonRule {
    func validate(with text: String) -> (isValid: Bool, message: String)
}

public final class ValidationButtonRuleComposite: ValidationButtonRule {
    private var rules: [ValidationButtonRule] = []
    
    public init(rules: ValidationButtonRule...) {
        self.rules = rules
    }
    
    public func validate(with text: String) -> (isValid: Bool, message: String) {
        for rule in rules {
            let validationResult = rule.validate(with: text)
            if validationResult.isValid == false {
                return validationResult
            }
        }
        
        return (true, "")
    }
}

public final class ValidationButtonRuleLeaf: ValidationButtonRule {
    private let message: String
    private let predicate: (String) -> Bool
    
    public init(message: String, predicate: @escaping (String) -> Bool) {
        self.message = message
        self.predicate = predicate
    }
    
    public func validate(with text: String) -> (isValid: Bool, message: String) {
        (predicate(text), message)
    }
    
    public static func getNotEmptyCategoryRule() -> ValidationButtonRule {
        getNotEmptyRule(message: "Please provide the Name for the Category")
    }
    
    public static func getNotEmptyItemRule() -> ValidationButtonRule {
        getNotEmptyRule(message: "Please provide the Name for the Item")
    }
    
    private static func getNotEmptyRule(message: String) -> ValidationButtonRule {
        ValidationButtonRuleLeaf(message: message, predicate: { $0 != "" })
    }
}
