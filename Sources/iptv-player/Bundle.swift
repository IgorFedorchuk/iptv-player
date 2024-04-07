//
//  Bundle.swift
//
//
//  Created by Igor Fedorchuk on 06.04.2024.
//

import Foundation

extension Bundle {
    static var framework: Bundle {
        class Class {}
        #if SWIFT_PACKAGE
            return .module
        #else
            return Bundle(for: Class.self)
        #endif
    }
}
