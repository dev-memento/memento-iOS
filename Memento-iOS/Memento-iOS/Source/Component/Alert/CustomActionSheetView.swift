//
//  CustomActionSheetView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/19/25.
//

import SwiftUI

struct CustomActionSheetView: View {
    
    @State private var isActionSheetShow = false
    @State private var isRepeated = false
    @State private var itemType: ItemType = .schedule
    @State private var actionType: ActionType = .delete
    
    var body: some View {
        VStack {
            Button("Show Delete for Repeated Schedule") {
                isRepeated = true
                itemType = .schedule
                actionType = .delete
                isActionSheetShow = true
            }
            
            Button("Show Edit for Repeated Schedule") {
                isRepeated = true
                itemType = .schedule
                actionType = .edit
                isActionSheetShow = true
            }
            
            Button("Show Delete for Non-Repeated Todo") {
                isRepeated = false
                itemType = .todo
                actionType = .delete
                isActionSheetShow = true
            }
            
            .confirmationDialog(
                dialogTitle(),
                isPresented: $isActionSheetShow,
                titleVisibility: .visible
            ) {
                if isRepeated {
                    if actionType == .delete {
                        Button(singleDeleteText()) {
                            handleAction(action: .singleDelete)
                        }
                        Button(multipleDeleteText()) {
                            handleAction(action: .multipleDelete)
                        }
                    } else if actionType == .edit {
                        Button(singleEditText()) {
                            handleAction(action: .singleEdit)
                        }
                        Button(multipleEditText()) {
                            handleAction(action: .multipleEdit)
                        }
                    }
                } else {
                    if actionType == .delete {
                        Button(defaultDeleteText() , role: .destructive) {
                            handleAction(action: .defaultDelete)
                        }
                    }
                }
                Button("Cancel", role: .cancel) {
                    print("취소")
                }
            }
        }
    }

    private func handleAction(action: Action) {
        switch action {
        case .singleDelete:
            print("Delete This Only")
        case .multipleDelete:
            print("Delete All")
        case .singleEdit:
            print("Save This Only")
        case .multipleEdit:
            print("Save All")
        case .defaultDelete:
            print("Delete Single")
        }
    }
}

extension CustomActionSheetView {
    enum Action {
        case singleDelete   // 단일 삭제
        case multipleDelete // 다중 삭제
        case singleEdit     // 단일 수정
        case multipleEdit   // 다중 수정
        case defaultDelete  // 기본 삭제
    }

    enum ItemType {
        case schedule
        case todo
    }
    
    enum ActionType {
        case delete
        case edit
    }
}

private extension CustomActionSheetView {
    
    func dialogTitle() -> String {
        if isRepeated {
            switch actionType {
            case .delete:
                return itemType == .schedule
                    ? "Do you really want to delete this event?\nThis is a repeating event."
                    : "Are you sure you want to delete this task?\nThis is a repeating task."
            case .edit:
                return itemType == .schedule
                    ? "This is a repeating event"
                    : "This is a repeating task"
            }
        }
        return ""
    }
    
    
    func singleDeleteText() -> String {
        return itemType == .schedule ? "Delete This Event Only" : "Delete This Task Only"
    }
    
    func multipleDeleteText() -> String {
        return itemType == .schedule ? "Delete All Upcoming Events" : "Delete All Upcoming Tasks"
    }
    
    func singleEditText() -> String {
        return itemType == .schedule ? "Save for This Event Only" : "Save for This Task Only"
    }
    
    func multipleEditText() -> String {
        return itemType == .schedule ? "Save for Upcoming Events" : "Save for Upcoming Tasks"
    }

    func defaultDeleteText() -> String {
        return itemType == .schedule ? "Delete Event" : "Delete Task"
    }
}
