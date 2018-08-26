import UIKit

class ButtonWithHighlight: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            updateBackgroundColor(wasHighlighter: oldValue)
        }
    }

    private func updateBackgroundColor(wasHighlighter: Bool) {
        guard isEnabled else { return }
        guard isHighlighted != wasHighlighter else { return }
        
        if isHighlighted {
            backgroundColor = UIColor(white: 0, alpha: 0.1)
        } else {
            backgroundColor = .clear
        }
    }
}
