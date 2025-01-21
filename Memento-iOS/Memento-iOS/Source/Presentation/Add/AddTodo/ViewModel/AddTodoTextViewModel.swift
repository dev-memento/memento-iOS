//
//  AddTodoTextViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import Foundation

final class AddTodoTextViewModel: ObservableObject {

    @Published var text: String = ""
    @Published var shouldFocus: Bool = false

    var isTextEmpty: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func limitTextLength(_ newText: String) {
        let lines = newText.split(whereSeparator: \.isNewline)

        if let lastLine = lines.last, lastLine.count > 30 {
            let truncated = String(lastLine.prefix(30))
            text = lines.dropLast()
                        .map(String.init)
                        .joined(separator: "\n") + "\n" + truncated + "\n"
        } else {
            text = newText
        }
    }
}
