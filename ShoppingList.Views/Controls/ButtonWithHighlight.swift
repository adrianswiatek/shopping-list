import UIKit

public final class ButtonWithHighlight: UIButton {
    public override var isHighlighted: Bool {
        didSet {
            updateBackgroundColor(wasHighlighter: oldValue)
        }
    }

    private func updateBackgroundColor(wasHighlighter: Bool) {
        guard isEnabled, isHighlighted != wasHighlighter else { return }
        backgroundColor = isHighlighted ? UIColor(white: 0, alpha: 0.1) : .clear
    }
}
