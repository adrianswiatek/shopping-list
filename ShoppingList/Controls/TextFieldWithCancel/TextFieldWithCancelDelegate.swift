import UIKit

@objc protocol TextFieldWithCancelDelegate {
    @objc optional func textFieldWithCancel(_ textFieldWithCancel: UITextField, didReturnWith text: String)
    @objc optional func textFieldWithCancelDidCancel(_ textFieldWithCancel: UITextField)
}
