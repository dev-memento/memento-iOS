//
//  TodoDataModel.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/13/25.
//

import Foundation

struct TodoDataModel: Identifiable {
    var id = UUID()
    var title: String
    var dueDate: String
    var priority: Priority
    var isChecked: Bool
    var tagColor: String
}
