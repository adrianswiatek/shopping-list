import UIKit

public struct BottomShadowAnimations {
    private let view: UIView
    
    private let opacityAnimation: CABasicAnimation
    private let normalOpacity: Float = 0.1
    private let editOpacity: Float = 0.2
    
    private let offsetAnimation: CABasicAnimation
    private let normalOffset = CGSize(width: 0, height: 1)
    private let editOffset = CGSize(width: 0, height: 2)
    
    public init(_ view: UIView) {
        self.view = view
        
        self.opacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        self.opacityAnimation.duration = 0.2
        
        self.offsetAnimation = CABasicAnimation(keyPath: "shadowOffset")
        self.offsetAnimation.duration = 0.2
    }
    
    public func showNormalShadow() {
        opacityAnimation.fromValue = editOpacity
        opacityAnimation.toValue = normalOpacity
        view.layer.add(opacityAnimation, forKey: nil)
        view.layer.shadowOpacity = normalOpacity
        
        offsetAnimation.fromValue = editOffset
        offsetAnimation.toValue = normalOffset
        view.layer.add(offsetAnimation, forKey: nil)
        view.layer.shadowOffset = normalOffset
    }
    
    public func showEditShadow() {
        opacityAnimation.fromValue = normalOpacity
        opacityAnimation.toValue = editOpacity
        view.layer.add(opacityAnimation, forKey: nil)
        view.layer.shadowOpacity = editOpacity
        
        offsetAnimation.fromValue = normalOffset
        offsetAnimation.toValue = editOffset
        view.layer.add(offsetAnimation, forKey: nil)
        view.layer.shadowOffset = editOffset
    }
}
