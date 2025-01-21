//
//  Tag.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct Tag: Identifiable {
    let id: UUID
    var color: Color
    var title: String

    init(id: UUID = UUID(), color: Color, title: String) {
        self.id = id
        self.color = color
        self.title = title
    }
}

extension Tag {

    static let mockData: [Tag] = [
        Tag(color: .gray02, title: "Untitled"),
        Tag(color: .mementoBlue, title: "SOPT"),
        Tag(color: .mementoCyan, title: "School"),
        Tag(color: .mementoMint, title: "Project"),
        Tag(color: .mementoLightGreen, title: "Meeting"),
        Tag(color: .mementoYellow, title: "Daily")
    ]
}
