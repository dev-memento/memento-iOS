//
//  TabBarItem.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/7/25.
//

import SwiftUI

import MCalendar

enum TabBarItem: CaseIterable {
    
    case today, addition, todo
    
    // 선택되지 않은 탭
    var normalItem: Image {
        switch self {
        case .today:
            return Image(.btn_today_unselected)
        case .addition:
            return Image(.btn_add_unselected)
        case .todo:
            return Image(.btn_todo_unselected)
        }
    }
    
    // 선택된 탭
    var selectedItem: Image {
        switch self {
        case .today:
            return Image(.btn_today_selected)
        case .addition:
            return Image(.btn_add_selected)
        case .todo:
            return Image(.btn_todo_selected)
        }
    }
}

