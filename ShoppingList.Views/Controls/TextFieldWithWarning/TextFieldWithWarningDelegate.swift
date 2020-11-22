import Foundation

@objc protocol TextFieldWithWarningDelegate {
    @objc optional func textFieldWithWarning(_ textFieldWithWarning: TextFieldWithWarning, didReturnWith text: String)
    @objc optional func textFieldWithWarningDidCancel(_ textFieldWithWarning: TextFieldWithWarning)
}
