//
//  String+.swift
//  Memento-iOS
//
//  Created by RAFA on 4/10/25.
//

import Foundation

extension String {

    func base64Padded() -> String {
        let padding = 4 - count % 4
        return self + String(repeating: "=", count: padding % 4)
    }
}
