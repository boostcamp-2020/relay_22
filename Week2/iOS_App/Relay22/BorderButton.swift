//
//  BorderButton.swift
//  Relay22
//
//  Created by TTOzzi on 2020/08/07.
//  Copyright © 2020 gicho. All rights reserved.
//

import UIKit

@IBDesignable
final class BorderButton: UIButton {

    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @IBInspectable var borderColor: UIColor {
        get { UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor) }
        set { layer.borderColor = newValue.cgColor }
    }
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    private var isClicked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        self.addTarget(self, action: #selector(animate(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(animate(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(animate(_:)), for: .touchUpOutside)
    }
    
    private func scaleUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .allowUserInteraction, animations: {
            sender.transform = .identity
        })
    }
    
    private func scaleDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .allowUserInteraction, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        })
    }
    
    @objc private func animate(_ sender: UIButton) {
        isClicked.toggle()
        isClicked ? scaleDown(sender) : scaleUp(sender)
    }
}
