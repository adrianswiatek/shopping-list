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
    
    public static var notEmptyCategoryRule: ValidationButtonRule {
        notEmptyRule(message: "Please provide name for the Category")
    }
    
    public static var notEmptyItemRule: ValidationButtonRule {
        notEmptyRule(message: "Please provide name for the Item")
    }

    public static var validUrlOrEmptyRule: ValidationButtonRule {
        let predicate: (String) -> Bool = { $0.isEmpty || URL(string: $0)?.host() != nil }
        return ValidationButtonRuleLeaf(message: "Please provide valid URL", predicate: predicate)
    }

    private static func notEmptyRule(message: String) -> ValidationButtonRule {
        let predicate: (String) -> Bool = { $0.isNotEmpty }
        return ValidationButtonRuleLeaf(message: message, predicate: predicate)
    }
}
