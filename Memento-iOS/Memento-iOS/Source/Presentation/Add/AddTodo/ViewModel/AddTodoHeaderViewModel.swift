//
//  AddTodoHeaderViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import Foundation

final class AddTodoHeaderViewModel: ObservableObject {

    @Published var showDatePicker: Bool = false
    @Published var selectedDate: Date = Date()
}
