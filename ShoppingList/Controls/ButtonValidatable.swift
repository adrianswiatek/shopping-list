import UIKit

protocol ButtonValidatable {
    func setDuplicatedValidation(_ message: String, isDuplicated: @escaping (String) -> Bool)
    func setEmptyTextValidation(_ message: String)
    func validate() -> Bool
    func getValidationMessage() -> String
}
