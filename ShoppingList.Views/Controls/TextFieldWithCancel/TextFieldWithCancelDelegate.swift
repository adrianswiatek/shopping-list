import UIKit

@objc
public protocol TextFieldWithCancelDelegate: AnyObject {
    @objc
    optional func textFieldWithCancel(_ textFieldWithCancel: TextFieldWithCancel, didReturnWith text: String)
}
