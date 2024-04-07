//
//  UIColor.swift
//  m3u8player
//
//  Created by Igor on 28.08.2022.
//

import UIKit

extension UIColor {
    // swiftlint:disable:next identifier_name
    static func color(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
}
