//
//  String.swift
//  m3u8player
//
//  Created by Igor on 22.08.2022.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func replacingSuffixIfCan(of pattern: String, with replacement: String) -> String {
        guard let range = range(of: pattern + "$", options: .regularExpression) else {
            return self
        }
        return replacingCharacters(in: range, with: replacement)
    }
}
