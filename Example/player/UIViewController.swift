//
//  UIViewController.swift
//  player
//
//  Created by Igor Fedorchuk on 07.04.2024.
//

import UIKit

extension UIViewController {
    class func topViewController(_ base: UIViewController? =
                                 UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController

            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(top)
            } else if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }

        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }

        return base
    }
}
