import UIKit
import SnapKit
import RiveRuntime

// MARK: - UIView Extensions
extension UIView {
    
    // MARK: Positioning
    @discardableResult
    func positionAboveTop(_ offset: CGFloat) -> Self {
        guard let superview = self.superview else { return self }
        snp.makeConstraints { $0.top.equalTo(superview).offset(offset) }
        return self
    }
    
    @discardableResult
    func centerX() -> Self {
        guard let superview = self.superview else { return self }
        snp.makeConstraints { $0.centerX.equalTo(superview) }
        return self
    }
    
    @discardableResult
    func centerY() -> Self {
        guard let superview = self.superview else { return self }
        snp.makeConstraints { $0.centerY.equalTo(superview) }
        return self
    }
    
    @discardableResult
    func below(_ view: UIView, _ offset: CGFloat) -> Self {
        snp.makeConstraints { $0.top.equalTo(view.snp.bottom).offset(offset) }
        return self
    }

    // MARK: Sizing
    @discardableResult
    func size(_ width: CGFloat, _ height: CGFloat) -> Self {
        snp.makeConstraints { $0.width.equalTo(width); $0.height.equalTo(height) }
        return self
    }
    
    // MARK: Styling
    @discardableResult
    func styledWithBlurEffect() -> Self {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        return self
    }

    // MARK: Misc
    func fullScreen() {
        guard let superview = self.superview else { return }
        snp.makeConstraints { $0.edges.equalTo(superview) }
    }
    
    func positionAtTop(_ offset: CGFloat) {
        guard let superview = self.superview else { return }
        snp.makeConstraints {
            $0.top.equalTo(superview).offset(offset)
            $0.centerX.equalTo(superview)
        }
    }
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}

// MARK: - UIButton Extensions
extension UIButton {
    
    @discardableResult
    func withTitle(_ title: String) -> Self {
        setTitle(title, for: .normal)
        return self
    }
    
    @discardableResult
    func withTextColor(_ color: UIColor) -> Self {
        setTitleColor(color, for: .normal)
        return self
    }
    
    @discardableResult
    func withTarget(_ target: Any?, action: Selector) -> Self {
        addTarget(target, action: action, for: .touchUpInside)
        return self
    }
    
    @discardableResult
    func withBackgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
    
    @discardableResult
    func withCornerRadius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        return self
    }
}

// MARK: - UITextField Extensions
extension UITextField {
    
    @discardableResult
    func styledAsRoundedRect() -> Self {
        borderStyle = .roundedRect
        return self
    }
    
    @discardableResult
    func withPlaceholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }
    
    @discardableResult
    func secured() -> Self {
        isSecureTextEntry = true
        return self
    }
}

// MARK: - UILabel Extensions
extension UILabel {
    
    @discardableResult
    func withText(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    func withFont(_ size: CGFloat) -> Self {
        font = UIFont.systemFont(ofSize: size)
        return self
    }
}


//MARK: - RiveView extension
extension RiveView {
    func withViewModel(_ viewModel: RiveViewModel) -> RiveView {
        viewModel.setView(self)
        return self
    }
}

