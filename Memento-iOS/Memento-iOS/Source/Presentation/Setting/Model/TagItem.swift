//
//  CategoryItem.swift
//  Memento-iOS
//
//  Created by 정정욱 on 3/26/25.
//

import SwiftUI

struct TagItem: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
    let isChevronVisible: Bool
}
