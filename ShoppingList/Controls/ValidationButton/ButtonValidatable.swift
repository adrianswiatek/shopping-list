import UIKit

protocol ButtonValidatable {
    func set(_ validationRule: ValidationButtonRule)
    func isValid() -> Bool
    func getValidationMessage() -> String
}