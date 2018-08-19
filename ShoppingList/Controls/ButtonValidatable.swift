import UIKit

protocol ButtonValidatable {
    func setEmptyTextValidationMessage(_ message: String)
    func isValid() -> Bool
}
