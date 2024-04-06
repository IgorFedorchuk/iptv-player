//
//  UIView.swift
//  m3u8player
//
//  Created by Igor on 24.08.2022.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    var maskedCorners: CACornerMask {
        get {
            return layer.maskedCorners
        }
        set {
            layer.maskedCorners = newValue
        }
    }

    func fillSuperview(with insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: insets.left).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -insets.right).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = true
        }
    }
}
