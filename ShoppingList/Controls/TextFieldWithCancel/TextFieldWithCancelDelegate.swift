import UIKit

@objc protocol TextFieldWithCancelDelegate {
    @objc optional func textFieldWithCancel(_ textFieldWithCancel: TextFieldWithCancel, didReturnWith text: String)
    @objc optional func textFieldWithCancelDidCancel(_ textFieldWithCancel: TextFieldWithCancel)
}
