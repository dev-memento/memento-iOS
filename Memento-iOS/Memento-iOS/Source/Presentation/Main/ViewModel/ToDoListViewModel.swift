//
//  ToDoListViewModel.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/17/25.
//

import SwiftUI

import MDSKit

final class ToDoListViewModel: ObservableObject {
    @Published var toDoListItems: [String: [ToDoListDataModel]] = [
        "Jan 3": [
            ToDoListDataModel(colorType: "mementoRed", toDoTitle: "투두1", dueDate: "Today", priorityType: .immediate, isChecked: false),
            ToDoListDataModel(colorType: "mementoBlue", toDoTitle: "투두2", dueDate: "Today", priorityType: .medium, isChecked: false),
            ToDoListDataModel(colorType: "mementoYellow", toDoTitle: "투두3", dueDate: "Today", priorityType: .high, isChecked: false),
            ToDoListDataModel(colorType: "mementoLightGreen", toDoTitle: "투두4", dueDate: "Today", priorityType: .none, isChecked: false)
        ],
        "Jan 4": [],
        "Jan 5": [
            ToDoListDataModel(colorType: "mementoPink", toDoTitle: "투두5", dueDate: "Today", priorityType: .immediate, isChecked: false)
        ]
    ]
}
