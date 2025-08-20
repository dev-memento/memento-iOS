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
        VStack { // 예시 버튼
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
        }
        .confirmationDialog(
            isRepeated ? actionType.dialogTitle(for: itemType) : "",
            isPresented: $isActionSheetShow,
            titleVisibility: isRepeated ? .visible : .hidden
        ) {
            ForEach(actions, id: \.self) { action in
                Button(action.buttonTitle(for: itemType), role: action.role) {
                    handleAction(action: action)
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private var actions: [Action] {
        if isRepeated {
            switch actionType {
            case .delete: return [.singleDelete, .multipleDelete]
            case .edit:   return [.singleEdit, .multipleEdit]
            }
        } else {
            return actionType == .delete ? [.defaultDelete] : []
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

// MARK: - CustomActionSheetView 관련 Enum 정의 (항목/동작/버튼 텍스트)
extension CustomActionSheetView {
    enum ItemType {
        case schedule
        case todo
    }
    
    enum ActionType {
        case delete
        case edit
        
        // 액션 시트 타이틀 반환
        func dialogTitle(for itemType: ItemType) -> String {
            switch (self, itemType) {
            case (.delete, .schedule):
                return "Do you really want to delete this event?\nThis is a repeating event."
            case (.delete, .todo):
                return "Are you sure you want to delete this task?\nThis is a repeating task."
            case (.edit, .schedule):
                return "This is a repeating event"
            case (.edit, .todo):
                return "This is a repeating task"
            }
        }
    }
    
    // 실제 버튼 액션 정의
    enum Action: Hashable {
        case singleDelete
        case multipleDelete
        case singleEdit
        case multipleEdit
        case defaultDelete
        
        // 각 버튼별 텍스트 반환
        func buttonTitle(for itemType: ItemType) -> String {
            switch (self, itemType) {
            case (.singleDelete, .schedule): return "Delete This Event Only"
            case (.singleDelete, .todo):     return "Delete This Task Only"
            case (.multipleDelete, .schedule): return "Delete All Upcoming Events"
            case (.multipleDelete, .todo):     return "Delete All Upcoming Tasks"
            case (.singleEdit, .schedule):   return "Save for This Event Only"
            case (.singleEdit, .todo):       return "Save for This Task Only"
            case (.multipleEdit, .schedule): return "Save for Upcoming Events"
            case (.multipleEdit, .todo):     return "Save for Upcoming Tasks"
            case (.defaultDelete, .schedule): return "Delete Event"
            case (.defaultDelete, .todo):     return "Delete Task"
            }
        }
        
        var role: ButtonRole? {
            self == .defaultDelete ? .destructive : nil
        }
    }
}


struct CustomActionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        CustomActionSheetView()
            .previewLayout(.sizeThatFits)
    }
}
