//
//  UIImage.swift
//
//
//  Created by Igor Fedorchuk on 06.04.2024.
//

import UIKit

extension UIImage {
    convenience init?(imageName: String) {
        self.init(named: imageName, in: Bundle.framework, compatibleWith: nil)
    }
}
