//
//  AddEventTitleViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import Foundation

final class AddEventTitleViewModel: ObservableObject {

    @Published var title: String = ""

    var isTitleEmpty: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
