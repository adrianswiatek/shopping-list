import UIKit

@objc
public protocol TextFieldWithCancelDelegate: class {
    @objc
    optional func textFieldWithCancel(_ textFieldWithCancel: TextFieldWithCancel, didReturnWith text: String)
}
