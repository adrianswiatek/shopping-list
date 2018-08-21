protocol ValidationButtonRule {
    func validate(with text: String) -> (isValid: Bool, message: String)
}

class ValidationButtonRuleComposite: ValidationButtonRule {
    
    private var rules: [ValidationButtonRule] = []
    
    init(rules: ValidationButtonRule...) {
        self.rules = rules
    }
    
    func validate(with text: String) -> (isValid: Bool, message: String) {
        for rule in rules {
            let validationResult = rule.validate(with: text)
            if validationResult.isValid == false {
                return validationResult
            }
        }
        
        return (true, "")
    }
}

class ValidationButtonRuleLeaf: ValidationButtonRule {
    
    private let message: String
    private let predicate: (String) -> Bool
    
    init(message: String, predicate: @escaping (String) -> Bool) {
        self.message = message
        self.predicate = predicate
    }
    
    func validate(with text: String) -> (isValid: Bool, message: String) {
        return (predicate(text), message)
    }
}
